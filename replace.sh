LD_STRING="g45p1svt w=390.00n l=45n as=9.45e-15 ad=9.45e-15 \
        ps=300n pd=300n ld=105n ls=105n m=1"
NEW_STRING="g45p1svt w=(390n) l=45n nf=1 as=54.6f ad=54.6f \
        ps=1.06u pd=1.06u nrd=358.974m nrs=358.974m sa=140n sb=140n \
        sd=160n sca=114.89040 scb=0.09003 scc=0.01377 m=(1)"

# 使用 sed 命令递归替换文件中的内容
find ACLD -type f -exec sed -i "s|${OLD_STRING}|${NEW_STRING}|g" {} \;


