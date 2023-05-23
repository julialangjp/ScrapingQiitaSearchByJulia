# ScrapingQiitaSearchByJulia
Qiitaの検索ページからJuliaタグ最新記事のリンクとタイトルを取得します

## Installation
```julia
using Pkg
Pkg.add("HTTP")
Pkg.add("Gumbo")
Pkg.add("Cascadia")
Pkg.add("URIs")
```

## Usage
### コンソールで実行
```julia
> julia getQiitaSearch.jl
```

### 結果出力
日付付きのファイルに出力されます。  
例） qiitas20220418.txt

TSV形式：行に一組の見出しとURLがTAB区切りで格納されます。

## 備考
　QiitaのJuliaタグの検索ページのURLを埋め込んであります。ここを書き換えることでほかの検索結果のスクレイピングも可能です。  

## 参照
　次のページに簡単な解説を書きました。  
　　  [スクレイピング(3)：Qiitaの検索ページからJuliaタグ最新記事のリンクとタイトルを取得](https://leadinge.co.jp/julialang/2022/04/18/scraping_qiita2/)
