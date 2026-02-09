#!/bin/bash

# CodeMate Mobile 快速构建脚本
# 使用方法: ./quick-build.sh [build-type]

echo "🚀 CodeMate Mobile 快速构建"
echo "=============================="

# 检查环境
check_environment() {
    echo "🔧 检查构建环境..."
    
    if ! command -v java &> /dev/null; then
        echo "❌ Java未安装，请安装JDK 17+"
        exit 1
    fi
    
    if [ -z "$ANDROID_HOME" ]; then
        echo "❌ ANDROID_HOME未设置"
        echo "请设置Android SDK路径"
        exit 1
    fi
    
    echo "✅ 环境检查通过"
}

# 快速构建Debug
build_debug() {
    echo "🔨 构建Debug版本..."
    ./gradlew assembleDebug --no-daemon
    echo "✅ Debug APK: app/build/outputs/apk/debug/app-debug.apk"
}

# 快速构建Release
build_release() {
    echo "🔨 构建Release版本..."
    ./gradlew assembleRelease --no-daemon
    echo "✅ Release APK: app/build/outputs/apk/release/app-release.apk"
}

# 运行测试
run_tests() {
    echo "🧪 运行测试..."
    ./gradlew test --no-daemon
    echo "✅ 测试完成"
}

# 主函数
main() {
    check_environment
    
    if [ $# -eq 0 ]; then
        echo ""
        echo "请选择操作:"
        echo "1) 构建Debug APK"
        echo "2) 构建Release APK"
        echo "3) 运行测试"
        echo "4) 清理构建文件"
        echo "0) 退出"
        echo ""
        read -p "请输入选择 [0-4]: " choice
        
        case $choice in
            1) build_debug ;;
            2) build_release ;;
            3) run_tests ;;
            4) ./gradlew clean ;;
            0) echo "👋 再见！" ; exit 0 ;;
            *) echo "❌ 无效选择" ;;
        esac
    else
        case $1 in
            debug) build_debug ;;
            release) build_release ;;
            test) run_tests ;;
            clean) ./gradlew clean ;;
            help|--help|-h) echo "使用方法: $0 [debug|release|test|clean|help]" ;;
            *) echo "未知参数: $1" ;;
        esac
    fi
}

main "$@"