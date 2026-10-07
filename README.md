# dify4go

当前仅初始化 Go module、Gin 最小 HTTP 入口、Vue 3 + TypeScript + Vite，以及 Docker 部署配置。后端只有 `/healthz`，前端只有初始页面。

Agent、工作流、配置加载、数据库接入和迁移尚未实现。后续按 [MVP 项目设计](docs/dify4go-MVP项目设计.md) 分阶段开发。

## 本地启动

需要 Go 1.26.5 或更新版本、Node.js `^22.18.0 || >=24.12.0` 和 pnpm 11.24.0。

在仓库根目录启动后端：

```sh
go run -tags=nomsgpack ./cmd/dify4go
```

访问 `http://127.0.0.1:8080/healthz`。

另开终端启动前端：

```sh
cd webui
pnpm install --frozen-lockfile
pnpm dev
```

默认访问 `http://localhost:5173`。前端目前不请求后端。

## Docker Compose

需要运行中的 Docker Linux 容器引擎。先复制环境文件并修改数据库密码：

```powershell
Copy-Item .env.example .env
```

```sh
docker compose up -d --build
```

默认入口：Web UI 为 `http://127.0.0.1:3000`，API 为 `http://127.0.0.1:8080/healthz`，PostgreSQL 为 `127.0.0.1:5432`。端口通过 `.env` 调整。

Compose 保留 PostgreSQL 服务供后续开发使用，目前 API 不连接数据库。Web UI 使用 Nginx 提供静态页面，并预留 `/healthz`、`/v1` 到 API 的代理。

停止执行 `docker compose down`，保留 PostgreSQL 命名数据卷。`.env`、前端依赖和构建产物均已忽略。

## 构建检查

```sh
go build -tags=nomsgpack ./...
go vet -tags=nomsgpack ./...
pnpm --dir webui build
docker compose --env-file .env.example config --quiet
```

`nomsgpack` 关闭 Gin 中暂不需要的 MsgPack 编译路径。Compose 配置校验不等同于镜像构建或容器运行验证。
