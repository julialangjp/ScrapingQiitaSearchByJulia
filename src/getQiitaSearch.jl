using HTTP
using Gumbo
using Cascadia
using URIs
using Dates

# Get the titles and URLs of Qiita's Search Page
# Qiitaの検索ページからJuliaタグ最新記事のリンクとタイトルを取得
function get_qiita_search(tgt_url::String)
    # get a html page : HTMLを取得
    response = HTTP.request("GET", tgt_url)
    if response.status != 200
        return nothing
    end

    code = String(response.body)
    doc = Gumbo.parsehtml(code)

    # get count of children : 子要素の数を取得
    len = length(doc.root.children)

    # get contents : <head>...</head> and <body>...</body>
    head = nothing
    body = nothing
    for i in 1:len
        if tag(doc.root[i]) == :head
            head = doc.root[i]
        elseif tag(doc.root[i]) == :body
            body = doc.root[i]
        end
    end

    # get main contents
    # 本文を取得
    list = []
    if !isnothing(body)
        # Get by specifying css selector -> get an array of matching elements
        # セレクターを指定して取得　→　一致する要素の配列を返す
        qs = eachmatch(Selector("h1 a"), body)
        for s in qs
            url = getattr(s, "href", nothing)
            if !isnothing(url)
                u = resolvereference(tgt_url, url)
                url_str = "$u"
                title = nodeText(s)
                pair = (title, url_str)
                push!(list, pair)
            end
        end
    end
    list
end

function main()
    url1 = "https://qiita.com/search?q=tag%3Ajulia&sort=created"
    url2 = "https://qiita.com/search?page=2&q=tag%3Ajulia&sort=created"

    # 日付付きのファイル名を作成
    filename = "qiitas" * Dates.format(now(), "yyyymmdd") * ".txt"
    open(filename, "w") do f
        list = get_qiita_search(url1)
        append!(list, get_qiita_search(url2))
        if isnothing(list)
            println(f, "Failed to get HTML.")
        else
            for (title, url) in list
                println(f, title * "\t" * url)
            end
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
