#!/bin/bash

# 检查是否安装了 Rust
if ! command -v cargo &> /dev/null; then
    echo "Cargo 未安装，请安装 Rust 工具链。"
    exit 1
fi

# 设置优化标志以减小 debug 构建的大小
export RUSTFLAGS="-C opt-level=1"

# 开始编译
echo "开始编译..."
cargo build

# 检查编译是否成功
if [ $? -ne 0 ]; then
    echo "编译失败，请检查错误信息。"
    exit 1
fi

# 获取二进制文件路径
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

