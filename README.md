## PCセットアップ
```
## セットアップ [root実行 ※sudoではなく]
curl -sL s.jwnr.net/mjr-i3 | sh


## ドットファイルデプロイ [ユーザー実行]
curl -sL d.jwnr.net | sh
```

<br><br>


## FWセットアップ

|  | npm |  | bun |  |
|:-|:-|:-|:-|:-|
| Astro       | npm create astro@latest      | [Astro](https://astro.build/)                   | bun create astro             | [Bun-Guide](https://bun.sh/guides/ecosystem/astro)     |
| SvelteKit   | npm create svelte@latest xxx | [SvelteKit](https://kit.svelte.dev/)            | bun create svelte@latest xxx | [Bun-Guide](https://bun.sh/guides/ecosystem/sveltekit) |
| Next.js     | npx create-next-app@latest   | [Next.js](https://nextjs.org/)                  | bun create next-app          | [Bun-Guide](https://bun.sh/guides/ecosystem/nextjs)    |
| hono        | npm create hono@latest xxx   | [Hono](https://hono.dev/getting-started/nodejs) | bun create hono xxx          | [Hono](https://hono.dev/getting-started/bun)<br>[Bun-Guide](https://bun.sh/guides/ecosystem/hono)  |
| Drizzle ORM |      | [Drizzle](https://orm.drizzle.team/) |      | [Drizzle](https://orm.drizzle.team/docs/get-started-sqlite#bun-sqlite)<br>[Bun-Guide](https://bun.sh/guides/ecosystem/drizzle)  |
| Prisma |      | [Prisma](https://www.prisma.io/) |      | [Prisma](https://www.prisma.io/docs/orm/tools/prisma-cli#bun)<br>[Bun-Guide](https://bun.sh/guides/ecosystem/prisma)  |


<br><br>


## Bun workspaces (モノレポ)
```
#### ディレクトリ構造
<root>
├ packages/      <--- pckgs, prjs, apps, etc...
│  ├ aaa         <-┐
│  ├ bbb         <-┴- package directorys
│  └ ...
├ bun.lockb
├ ...
├ package.json   <--- ## 要編集 ##
└ ...



#### <root>/package.json
{
  "name": "monorepo"
  ...
  "workspaces": [      <-┐
    "packages/*"       <-┼- 追記
  ],                   <-┘
  ...
}



#### <root>/packages/aaa/package.json
{
  "name": "aaa"      <--- 必須
  ...
}


```

<br><br>


## Svelte, Sveltekit


#### /src/app.html
```
<html lang="en">
  ↓
<html lang="ja">

<meta name="author" content="xxxx">

```


#### /src/routes/xxx.svelte
```
<svelte:head>
  <title>タイトル</title>
  <meta name="description" content="説明">
  <meta name="keywords" content="キーワード(もうほぼ不要)">
</svelte:head>

```
