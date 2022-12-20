#!/usr/bin/env bash

function getOsId() {
    osId=$(sed -n 's/^ID=\([[:alnum:]]*\)/\1/p' /etc/os-release)
}

function getOsCodeName() {
    osCodeName=$(sed -n 's/^VERSION_CODENAME=\([[:alnum:]]*\)/\1/p' /etc/os-release)
    if [ -z "$var" ]
    then
        osCodeName=$(sed -n 's/^VERSION=.*(\([[:alnum:]]*\).*/\1/p' /etc/os-release)
    fi
}

getOsCodeName
getOsId

case $osId in
    "ubuntu")
        ;;
    "debian")
        ;;
    *)
        echo "仅支持 debian 和 ubuntu"
        exit
        ;;
esac
echo ""
echo "当前系统是: ${osId} ${osCodeName}"
echo ""

PS3="选择镜像源(请输入选项数字): "
select mirrorName in '阿里云' '网易163' '中科大' '清华'
do
    case $mirrorName in
        "阿里云")
            mirrorUrl=http://mirrors.aliyun.com/${osId}/
            break
            ;;
        "网易163")
            mirrorUrl=http://mirrors.163.com/${osId}/
            break
            ;;
        "中科大")
            mirrorUrl=https://mirrors.ustc.edu.cn/${osId}/
            break
            ;;
        "清华")
            mirrorUrl=https://mirrors.tuna.tsinghua.edu.cn/${osId}/
            break
            ;;
        *)
            echo "输入的选项不存在"
            ;;
    esac
done

echo ""
echo "你选择的镜像源是: ${mirrorName} ($mirrorUrl)"

backupSourceslistFile="/etc/apt/sources.list.$(date '+%s')"
echo ""
echo "备份当前配置到 " ${backupSourceslistFile}
cp /etc/apt/sources.list ${backupSourceslistFile}

sed -nEi "s|https?://[^ ]+|${mirrorUrl}|p" /etc/apt/sources.list
echo "已完成镜像源替换, 执行 'apt update' 命令后生效"
