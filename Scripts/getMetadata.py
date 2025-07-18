"""
getMetadata.py
Usage:
  python getMetadata.py --input input.pdf --output output.json
If no arguments are provided, processes all PDFs in the default directory as before.
"""
import requests
from bs4 import BeautifulSoup
import re
import json
from time import sleep
import pandas as pd  # 引入 pandas 库
from pathlib import Path  # 用于处理文件路径
import os  # 用于遍历文件夹
import argparse

# 请求头
gheaders = {
    'Referer': 'https://ieeexplore.ieee.org/search/searchresult.jsp',
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
    'Accept-Encoding': 'gzip, deflate, br',
    'Accept-Language': 'en-US,en;q=0.5',
    'Connection': 'keep-alive'
}


def get_pdf_ids(pdf_dir):
    """Scan the directory and return a list of digital IDs in the format like 1234567.pdf"""
    pdf_ids = []
    for fname in os.listdir(pdf_dir):
        fname_stripped = fname.strip()
        match = re.search(r'(\d+)\.pdf$', fname_stripped, re.IGNORECASE)
        if match:
            pdf_ids.append(match.group(1))
    return pdf_ids

def get_ieee_abstract(articleNumber):
    """Get the abstract, keywords, DOI, title, venue, type, year, and authors for a single paper."""
    url = f'https://ieeexplore.ieee.org/document/{articleNumber}'

    try:
        response = requests.get(url=url, headers=gheaders, timeout=10)
        response.raise_for_status()  # Check for HTTP errors

        soup = BeautifulSoup(response.text, 'lxml')
        pattern = re.compile(r'xplGlobal\.document\.metadata=({.*?});', re.DOTALL)

        script = soup.find("script", string=pattern)

        if not script:
            print(f"Metadata not found: {articleNumber}")
            return None

        json_str = pattern.search(script.string).group(1)
        json_data = json.loads(json_str)
        abstract = json_data.get('abstract', '')  # Abstract
        keywords = json_data.get('keywords', [])  # Keywords
        doi = json_data.get('doi', '')            # DOI
        title = json_data.get('title', '')        # Title
        venue = json_data.get('publicationTitle', '')  # Venue/Journal
        pub_type = json_data.get('contentType', '')    # Type
        year = json_data.get('publicationYear', '')    # Year

        # Process authors
        authors_list = json_data.get('authors', [])
        if isinstance(authors_list, list):
            authors = ', '.join([a.get('name', '') for a in authors_list])
        else:
            authors = ''

        # Process keywords
        keywords_dict = {}
        for kw in keywords:
            kw_type = kw.get('type', 'Unknown')
            kw_list = kw.get('kwd', [])
            keywords_dict[kw_type] = ', '.join(kw_list)

        return {
            'articleNumber': articleNumber,
            'DOI': doi,
            'title': title,
            'venue': venue,
            'type': pub_type,
            'year': year,
            'authors': authors
        }

    except json.JSONDecodeError as json_err:
        print(f"JSON parsing error: {str(json_err)}")
    except Exception as e:
        print(f"Failed to get {articleNumber}: {str(e)}")
        return None


def process_single_pdf(input_pdf, output_json):
    # Extract article number from filename
    import re, os
    base_name = os.path.splitext(os.path.basename(input_pdf))[0]
    article_match = re.search(r'(\d+)', base_name)
    if not article_match:
        print(f"Could not extract article number from {input_pdf}")
        return
    doc_id = article_match.group(1)
    metadata = get_ieee_abstract(doc_id)
    with open(output_json, 'w', encoding='utf-8') as f:
        json.dump(metadata, f, indent=2, ensure_ascii=False)
    print(f"Processed {input_pdf} -> {output_json}")

def main():
    parser = argparse.ArgumentParser(description='Retrieve publication metadata from IEEE.')
    parser.add_argument('--input', type=str, help='Input PDF file')
    parser.add_argument('--output', type=str, help='Output JSON file')
    args = parser.parse_args()

    if args.input and args.output:
        process_single_pdf(args.input, args.output)
        return

    pdf_dir = "/home/ACLD/DataMining_script/script/output/test"
    pdf_ids = get_pdf_ids(pdf_dir)
    print(f"Found {len(pdf_ids)} PDF IDs: {pdf_ids}")
    results = []
    for doc_id in pdf_ids:
        metadata = get_ieee_abstract(doc_id)
        print(f"{doc_id}: {metadata}")
        results.append((doc_id, metadata))
    with open("ieee_metadata_results.txt", "w", encoding="utf-8") as f:
        for doc_id, metadata in results:
            f.write(f"{doc_id}\t{json.dumps(metadata, ensure_ascii=False)}\n")


if __name__ == "__main__":
    main()
