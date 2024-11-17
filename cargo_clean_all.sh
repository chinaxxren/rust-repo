#!/bin/bash

# 定义处理单个项目的函数
build_project() {
    local project_dir="$1"

    # 检查项目目录是否存在
    if [ ! -d "$project_dir" ]; then
        echo "警告：项目目录 $project_dir 不存在，跳过清理。"
        return 1
    fi    

    # 进入项目目录
    cd "$project_dir" || {
        echo "无法访问项目目录 $project_dir"
        return 1
    }

  
    if [ -f "Cargo.toml" ]; then
        echo "当前$project_dir 异常"
    else
        echo "警告：项目目录 $project_dir 中没有 Cargo.toml 文件，跳过清理。"
        return 1
    fi


    # 执行 cargo clean
    echo "正在 清理项目：$project_dir"
    cargo clean

    # 检查构建是否成功
    if [ $? -ne 0 ]; then
        echo " 清理失败，请检查错误信息。"
        return 1
    else
        echo "清理成功。"
    fi

    # 返回上一级目录
    cd - > /dev/null
}


#  遍历当前目录及其所有后代子目录，查找包含 Cargo.toml 文件的目录
find . -type f -name "Cargo.toml" | while read -r cargo_toml_file; do
    # 获取包含 Cargo.toml 文件的目录
    project_dir=$(dirname "$cargo_toml_file")

    # 检查 target 目录是否存在
    if [ -d "$project_dir/target" ]; then
        # 清理项目
        build_project "$project_dir"
    else
        echo "警告：项目目录 $project_dir 中没有 target 目录，跳过清理。"
    fi
done
