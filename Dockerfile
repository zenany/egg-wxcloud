# 二开推荐阅读[如何提高项目构建效率](https://developers.weixin.qq.com/miniprogram/dev/wxcloudrun/src/scene/build/speed.html)
# 时区设置：https://developers.weixin.qq.com/miniprogram/dev/wxcloudservice/wxcloudrun/src/development/timezone/
# Dockerfile 参考 https://github.com/WeixinCloud/wxcloudrun-koa/blob/main/Dockerfile

FROM node:22-alpine

# 容器默认时区为UTC，如需使用上海时间请启用以下时区设置命令
RUN apk add tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo Asia/Shanghai > /etc/timezone

# 使用 HTTPS 协议访问容器云调用证书安装
# RUN apk add ca-certificates

# 安装依赖包，如需其他依赖包，请到alpine依赖包管理(https://pkgs.alpinelinux.org/packages?name=php8*imagick*&branch=v3.13)查找。
# 选用国内镜像源以提高下载速度
# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tencent.com/g' /etc/apk/repositories \
# && apk add --update --no-cache nodejs npm

RUN node -v

# # 指定工作目录
WORKDIR /webapp

# 拷贝包管理文件
COPY package*.json /webapp/

# npm 源，选用国内镜像源以提高下载速度
RUN npm config set registry https://mirrors.cloud.tencent.com/npm/
# RUN npm config set registry https://registry.npm.taobao.org/

# npm 安装依赖
RUN npm install

# 将当前目录（dockerfile所在目录）下所有文件都拷贝到工作目录下（.dockerignore中文件除外）
# Egg 需要先编译再运行 https://www.eggjs.org/zh-CN/tutorials/typescript#%E8%BF%90%E8%A1%8C-npm-start-%E4%B8%8D%E4%BC%9A%E5%8A%A0%E8%BD%BD-ts
COPY . /webapp

# 编译 TS
RUN npm run tsc

# 执行启动命令
# 写多行独立的CMD命令是错误写法！只有最后一行CMD命令会被执行，之前的都会被忽略，导致业务报错。
# 请参考[Docker官方文档之CMD命令](https://docs.docker.com/engine/reference/builder/#cmd)
CMD ["npm", "start"]

# 暴露 80 端口
EXPOSE 80
