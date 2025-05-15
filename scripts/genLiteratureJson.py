import os
import json
from datetime import datetime
import re
import requests
from bs4 import BeautifulSoup
import PyPDF2
from tqdm import tqdm

# IEEE API请求头
headers = {
    'Referer': 'https://ieeexplore.ieee.org/search/searchresult.jsp',
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
    'Accept-Encoding': 'gzip, deflate, br',
    'Accept-Language': 'en-US,en;q=0.5',
    'Connection': 'keep-alive'
}

def get_ieee_metadata(articleNumber):
    """从IEEE获取论文元数据"""
    url = f'https://ieeexplore.ieee.org/document/{articleNumber}'
    try:
        response = requests.get(url=url, headers=headers, timeout=10)
        response.raise_for_status()

        soup = BeautifulSoup(response.text, 'lxml')
        pattern = re.compile(r'xplGlobal\.document\.metadata=({.*?});', re.DOTALL)
        script = soup.find("script", string=pattern)

        if not script:
            return None

        json_str = pattern.search(script.string).group(1)
        json_data = json.loads(json_str)
        
        return {
            'doi': json_data.get('doi', ''),
            'title': json_data.get('title', ''),
            'venue': json_data.get('publicationTitle', ''),
            'type': json_data.get('contentType', ''),
            'year': json_data.get('publicationYear', ''),
            'authors': [a.get('name', '') for a in json_data.get('authors', [])]
        }
    except Exception as e:
        print(f"获取元数据失败：{str(e)}")
        return None

def extract_text_from_pdf(pdf_path):
    """从PDF文件中提取文本"""
    try:
        with open(pdf_path, 'rb') as file:
            reader = PyPDF2.PdfReader(file)
            text = ""
            for page in reader.pages:
                text += page.extract_text()
            return text
    except Exception as e:
        print(f"读取PDF失败 {pdf_path}: {str(e)}")
        return ""

def extract_library_name(text):
    """从文本中提取库名"""
    marker_verbs = ["proposed", "introduced", "presented", "developed", "designed", "implemented"]
    sentences = re.split(r'[.!?;\n]', text)
    for sentence in sentences:
        sentence_lower = sentence.lower()
        if any(marker in sentence_lower for marker in marker_verbs):
            candidates = re.findall(r'\b([A-Z][a-zA-Z0-9\-]+(?:Lib|LIB|Library|library)?)\b', sentence)
            candidates += re.findall(r'\b([A-Z]{2,}(?:Lib|LIB|Library|library)?)\b', sentence)
            candidates = list(dict.fromkeys(candidates))
            if candidates:
                return candidates[0].upper()
    return None

def analyze_text_for_techniques(text):
    """分析文本以提取技术特征"""
    text_lower = text.lower()
    
    # 检查异步设计指标
    async_indicators = [
        'asynchronous', 'async', 'self-timed', 'handshake',
        'micropipeline', 'bundled-data', 'bundled-delay',
        'delay-insensitive', 'quasi delay insensitive',
        'qdi', 'single-track', 'timed-pipeline'
    ]
    is_async = any(indicator in text_lower for indicator in async_indicators)
    
    # 检查延迟模型
    delay_models = {
        'Self-Timed Micro-Pipeline': ['self-timed', 'asynchronous micropipeline', 'bundled-data', 'bundled-delay', 'micropipeline'],
        'QDI': ['qdi', 'quasi delay insensitive', 'quasi-delay-insensitive'],
        'Single-Track': ['single-track', 'single track', 'singletrack'],
        'Timed-Pipeline': ['timed-pipeline', 'timed pipeline', 'timedpipeline']
    }
    
    found_delay_model = None
    for model, keywords in delay_models.items():
        if any(keyword in text_lower for keyword in keywords):
            found_delay_model = model
            break
    
    # 检查相位协议和数据编码
    data_protocol = None
    phase_protocol = None
    
    # 数据编码协议
    data_protocols = {
        'Bundled-Data': ['bundled data', 'bundled-data', 'bd protocol', 'bundled'],
        'Dual-Rail': ['dual-rail', 'dual rail', 'dualrail', 'dual rail protocol'],
        'Single-Rail': ['single-rail', 'single rail', 'singlerail'],
        'Multi-Rail': ['multi-rail', 'multi rail', 'multirail', '1-of-n', '1ofn']
    }
    
    # 相位协议
    phase_protocols = {
        '2-phase': ['2-phase', 'two-phase', '2 phase', 'two phase', 'nrz', 'non-return-to-zero'],
        '4-phase': ['4-phase', 'four-phase', '4 phase', 'four phase', 'rz', 'return-to-zero']
    }
    
    # 检查数据编码协议
    for protocol, keywords in data_protocols.items():
        if any(kw in text_lower for kw in keywords):
            data_protocol = protocol
            break
    
    # 检查相位协议
    for protocol, keywords in phase_protocols.items():
        if any(kw in text_lower for kw in keywords):
            phase_protocol = protocol
            break
            
    # 如果找到了QDI延迟模型但没有明确的数据编码，默认为Dual-Rail
    if found_delay_model == 'QDI' and not data_protocol:
        data_protocol = 'Dual-Rail'
    
    # 如果找到了Self-Timed Micro-Pipeline但没有明确的数据编码，默认为Bundled-Data
    if found_delay_model == 'Self-Timed Micro-Pipeline' and not data_protocol:
        data_protocol = 'Bundled-Data'
    
    # 组合handshaking_protocol
    handshaking_protocol = []
    if data_protocol:
        handshaking_protocol.append(data_protocol)
    if phase_protocol:
        handshaking_protocol.append(phase_protocol)
    
    # 流水线结构
    pipeline_structure = 'Data-Control-Composition'  # 默认值
    if found_delay_model == 'Self-Timed Micro-Pipeline':
        pipeline_structure = 'Data-Control-Decomposition'
    elif found_delay_model == 'QDI':
        if any(kw in text_lower for kw in ['ncl', 'dims', 'pcsl', 'scl']):
            pipeline_structure = 'Data-Control-Decomposition'
    
    return {
        "isAsynchronous": is_async,
        "delayModel": found_delay_model,
        "datapathStructure": {
            "handshakingProtocol": handshaking_protocol,
            "pipelineStructure": pipeline_structure
        },
        "libraryName": extract_library_name(text)
    }

def create_json_structure():
    """创建基础JSON结构"""
    return {
        "metadata": {
            "version": "1.0.0",
            "lastUpdated": datetime.now().strftime("%Y-%m-%d"),
            "repositoryIdentifier": {
                "id": None,
                "doi": None,
                "category": "Asynchronoys Circuit Logic (ACL)"
            }
        },
        "publication": {
            "title": None,
            "venue": None,
            "type": "Journal/Conference/Magazine",
            "year": None,
            "authors": []
        },
        "techniques": {
            "isAsynchronous": True,
            "delayModel": None,
            "datapathStructure": {
                "handshakingProtocol": [],
                "pipelineStructure": None
            },
            "libraryName": None
        }
    }

def process_pdf_file(pdf_path):
    """处理单个PDF文件并返回JSON数据"""
    json_data = create_json_structure()
    
    # 提取文件名中的IEEE文章号（如果有）
    base_name = os.path.splitext(os.path.basename(pdf_path))[0]
    article_match = re.search(r'(\d+)', base_name)
    
    # 提取PDF文本
    pdf_text = extract_text_from_pdf(pdf_path)
    
    # 获取元数据
    if article_match:
        metadata = get_ieee_metadata(article_match.group(1))
        if metadata:
            json_data["metadata"]["repositoryIdentifier"]["doi"] = metadata["doi"]
            json_data["publication"].update({
                "title": metadata["title"],
                "venue": metadata["venue"],
                "type": metadata["type"],
                "year": metadata["year"],
                "authors": metadata["authors"]
            })
    
    # 分析技术特征
    if pdf_text:
        techniques = analyze_text_for_techniques(pdf_text)
        json_data["techniques"].update(techniques)
    
    return json_data, json_data["metadata"]["repositoryIdentifier"]["doi"]

def sanitize_filename(doi):
    """将DOI转换为有效的文件名"""
    if not doi:
        return None
    return re.sub(r'[<>:"/\\|?*]', '-', doi)

def main():
    # PDF文件目录
    pdf_dir = "pdf/test"
    
    # 创建输出目录
    output_dir = "literature_json"
    os.makedirs(output_dir, exist_ok=True)
    
    if os.path.exists(pdf_dir):
        pdf_files = [f for f in os.listdir(pdf_dir) if f.lower().endswith('.pdf')]
        pdf_files.sort()
        
        for filename in tqdm(pdf_files, desc="Processing PDFs"):
            pdf_path = os.path.join(pdf_dir, filename)
            
            json_data, doi = process_pdf_file(pdf_path)
            
            # 创建输出文件名
            if doi:
                json_filename = f"{sanitize_filename(doi)}.json"
            else:
                json_filename = f"{os.path.splitext(filename)[0]}.json"
            
            json_path = os.path.join(output_dir, json_filename)
            
            # 保存JSON文件
            with open(json_path, 'w', encoding='utf-8') as f:
                json.dump(json_data, f, indent=2, ensure_ascii=False)
            print(f"Processed {filename} -> {json_filename}")
    else:
        print(f"Directory {pdf_dir} does not exist!")

if __name__ == "__main__":
    main() 
