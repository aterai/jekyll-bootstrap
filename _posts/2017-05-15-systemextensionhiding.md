---
layout: post
category: swing
folder: SystemExtensionHiding
title: JFileChooserでローカライズされたシステムフォルダ名を使用しないよう設定
tags: [JFileChooser, WindowsLookAndFeel, UIManager]
author: aterai
pubdate: 2017-05-15T16:03:21+09:00
description: JFileChooserのPlacesBarでローカライズされたシステムフォルダ名が表示されないように設定します。
image: https://drive.google.com/uc?id=1tvYX3gC3OiwWr8vnG5346sqWtA5k3G29cg
comments: true
---
## 概要
`JFileChooser`の`PlacesBar`でローカライズされたシステムフォルダ名が表示されないように設定します。

{% download https://drive.google.com/uc?id=1tvYX3gC3OiwWr8vnG5346sqWtA5k3G29cg %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("FileChooser.useSystemExtensionHiding", Boolean.FALSE);
</code></pre>

## 解説
- 左: `false`ボタン
    - `JFileChooser`の`PlacesBar`でローカライズされたシステムフォルダ名を使用しない
        - 例: 「最近使った項目」が「`Recent`」
        - 例: 「デスクトップ」が「`Desktop`」
        - 例: 「ドキュメント」が「`Documents`」
        - 「`PC`」と「ネットワーク」は変化しない
    - `PlacesBar`でのみ変化し、`JFileChooser`本体ではローカライズされた名前が使用される
    - 起動直後か、`LookAndFeel`が変更された直後のみ切替が有効になる
        - `JFileChooser`を生成し直しても内部の`FileSystemView`はインスタンスを引き継ぐため
- 右: `true`ボタン
    - `WindowsLookAndFeel`のデフォルト
    - `JFileChooser`の`PlacesBar`でローカライズされたシステムフォルダ名が使用される

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JFileChooserのPlacesBarを非表示にする](https://ateraimemo.com/Swing/NoPlacesBarFileChooser.html)
- [JDK-8183529 JFilleChooser in "Detail view" does not change the Language of the column headings - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-8183529)

<!-- dummy comment line for breaking list -->

## コメント
