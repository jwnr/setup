
```
## セットアップ [root実行 ※sudoではなく]
curl -sL s.jwnr.net/mjr-i3 | sh


## ドットファイルデプロイ [ユーザー実行]
curl -sL d.jwnr.net | sh
```

|  | npm |  | bun |  |
|:-|:-|:-|:-|:-|
| Astro     | npm create astro@latest      | [Astro](https://astro.build/)                   | bun create astro             | [Bun-Guide](https://bun.sh/guides/ecosystem/astro)     |
| SvelteKit | npm create svelte@latest xxx | [SvelteKit](https://kit.svelte.dev/)            | bun create svelte@latest xxx | [Bun-Guide](https://bun.sh/guides/ecosystem/sveltekit) |
| Next.js   | npx create-next-app@latest   | [Next.js](https://nextjs.org/)                  | bun create next-app          | [Bun-Guide](https://bun.sh/guides/ecosystem/nextjs)    |
| hono      | npm create hono@latest xxx   | [Hono](https://hono.dev/getting-started/nodejs) | bun create hono xxx          | [Hono](https://hono.dev/getting-started/bun)<br>[Bun-Guide](https://bun.sh/guides/ecosystem/hono)  |


---

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
