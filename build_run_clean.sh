#!/bin/bash

# 处理清理操作的函数
cleanup() {
    echo "执行 cargo clean..."
    cargo clean
    echo "清理完成。"
}

# 捕获 INT 信号（Ctrl+C）和 EXIT 事件
trap cleanup INT EXIT

# 编译过程
echo "开始编译..."
cargo build

# 检查编译是否成功
if [ $? -ne 0 ]; then
    echo "编译失败，请检查错误信息。"
    exit 1
fi

# 获取编译后的二进制文件路径
binary_path=$(cargo metadata --format-version=1 --no-deps | jq -r '.target_directory')/debug/$(cargo metadata --format-version=1 --no-deps | jq -r '.packages[0].targets[] | select(.kind[0]=="bin") | .name')

if [ ! -f "$binary_path" ]; then
    echo "无法找到编译后的二进制文件。"
    exit 1
fi

# 显示二进制文件大小
echo "编译完成。二进制文件大小："
du -h "$binary_path"

# 运行调试版本
echo "运行调试版本..."
"$binary_path"

# 运行结束
echo "运行结束，已执行清理。"
