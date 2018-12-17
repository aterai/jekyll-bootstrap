---
layout: post
category: swing
folder: SelectedTextColor
title: JEditorPaneで選択した文字列の色反転を無効化
tags: [JEditorPane, HTMLEditorKit, StyleSheet]
author: aterai
pubdate: 2018-12-17T15:32:38+09:00
description: JEditorPaneで選択した文字のレンダリングに使用する色をnullにして選択文字色の変更を無効化します。
image: https://drive.google.com/uc?id=1Jv8dY71xTfQSscUwHdO-aekbqgRTFmfzwA
comments: true
---
## 概要
`JEditorPane`で選択した文字のレンダリングに使用する色を`null`にして選択文字色の変更を無効化します。

{% download https://drive.google.com/uc?id=1Jv8dY71xTfQSscUwHdO-aekbqgRTFmfzwA %}

## サンプルコード
<pre class="prettyprint"><code>HTMLEditorKit htmlEditorKit = new HTMLEditorKit();
htmlEditorKit.setStyleSheet(styleSheet);
editor.setEditorKit(htmlEditorKit);
editor.setEditable(false);
editor.setSelectedTextColor(null);
editor.setSelectionColor(new Color(0x64_88_AA_AA, true));
editor.setBackground(new Color(0xEE_EE_EE));
</code></pre>

## 解説
- 上:
    - 選択した文字をレンダリングする色は、`LookAndFeel`でのデフォルト
        - `WindowsLookAndFeel`の場合、白
- 下:
    - 選択した文字のレンダリングを`JTextComponent#setSelectedTextColor(null)`で無効化し、`CSS`で設定した文字色のまま表示
    - [JTextComponent#setSelectedTextColor(Color) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/JTextComponent.html#setSelectedTextColor-java.awt.Color-)のドキュメントには、「色に`null`を設定することは、`Color.black`と同じです。」と記述されているが、`JEditorPane`では文字列選択しても文字色は変更されなくなる

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JEditorPaneで選択色を半透明化](https://ateraimemo.com/Swing/SelectionColor.html)
- [JEditorPaneにソースコードをシンタックスハイライトして表示する](https://ateraimemo.com/Swing/SyntaxHighlightingEditorPane.html)
- [Java access files in jar causes java.nio.file.FileSystemNotFoundException - Stack Overflow](https://stackoverflow.com/questions/22605666/java-access-files-in-jar-causes-java-nio-file-filesystemnotfoundexception)

<!-- dummy comment line for breaking list -->

## コメント
