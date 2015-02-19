---
layout: post
category: swing
folder: ShowsRootHandles
title: JTreeのルートノードに展開折り畳みアイコンを表示する
tags: [JTree]
author: aterai
pubdate: 2015-02-09T00:08:57+09:00
description: JTreeのルートノードにノードの展開と折り畳みやその状態を表示するアイコン(ルートハンドル)を表示するかどうかを切り替えます。
comments: true
---
## 概要
`JTree`のルートノードにノードの展開と折り畳みやその状態を表示するアイコン(ルートハンドル)を表示するかどうかを切り替えます。

{% download https://lh3.googleusercontent.com/-UsJgMi0D1h0/VNd47dUqy8I/AAAAAAAANwc/NyIfxKP0SVw/s800/ShowsRootHandles.png %}

## サンプルコード
<pre class="prettyprint"><code>tree.setShowsRootHandles(false);
</code></pre>

## 解説
- 左: `setShowsRootHandles(true)`
    - ルートノードのルートハンドルを表示する
- 右: `setShowsRootHandles(false)`
    - ルートノードのルートハンドルを表示しない
    - `JTree#setRootVisible(false)`で、`TreeModel`のルートノードが非表示になっている場合は、`JTree`でルートノードのようになっているノードのルートハンドルが非表示になる

<!-- dummy comment line for breaking list -->

- - - -
- メモ
    - `apidoc`の日本語訳では、誤訳で意味が逆になっている
    - [http://docs.oracle.com/javase/jp/8/api/javax/swing/JTree.html#setShowsRootHandles-boolean-](http://docs.oracle.com/javase/jp/8/api/javax/swing/JTree.html#setShowsRootHandles-boolean-)
    
    		newValue - ルートハンドルを表示しない場合は true、そうでない場合はfalse
    - [http://docs.oracle.com/javase/8/docs/api/javax/swing/JTree.html#setShowsRootHandles-boolean-](http://docs.oracle.com/javase/8/docs/api/javax/swing/JTree.html#setShowsRootHandles-boolean-)
    
    		newValue - true if root handles should be displayed; otherwise, false
    - * 参考リンク [#o16f3827]
- [JTreeの展開、折畳みアイコンを非表示にする](http://ateraimemo.com/Swing/TreeExpandedIcon.html)

<!-- dummy comment line for breaking list -->

## コメント
