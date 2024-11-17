#!/bin/bash

# 处理清理操作的函数
cleanup() {
    echo "执行 cargo clean..."
    cargo clean
}

# 捕获 INT 信号（Ctrl+C）和 EXIT 事件
trap cleanup INT EXIT

# 正常执行 cargo run
echo "执行 cargo run..."
cargo run

# 当 cargo run 执行完毕或被中断时，触发 cleanup
echo "cargo run 结束，已执行清理。"

