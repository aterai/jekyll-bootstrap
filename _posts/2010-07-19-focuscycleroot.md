---
layout: post
title: JPanelをフォーカストラバーサルサイクルのルートにする
category: swing
folder: FocusCycleRoot
tags: [JPanel, Focus]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-07-19

## JPanelをフォーカストラバーサルサイクルのルートにする
`JPanel`がフォーカストラバーサルサイクルのルートになるように設定します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTNCX36INI/AAAAAAAAAaI/xunzBpsDJLk/s800/FocusCycleRoot.png)

### サンプルコード
<pre class="prettyprint"><code>JPanel p1 = new JPanel();
p1.setFocusCycleRoot(true);
p1.add(new JTextField(16));
</code></pre>

### 解説
上記のサンプルでは、各`JPanel`がそれぞれフォーカストラバーサルサイクルのルートになるように設定しています。

- 左の`JPanel`
    - `setFocusCycleRoot(true);`
- `右のJPanel`
    - `setFocusCycleRoot(true);`
    - `setFocusTraversalPolicyProvider(true);`
    - 順方向キーボードトラバーサルとリバースキーボードトラバーサルを入れ替え

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Focusの移動](http://terai.xrea.jp/Swing/FocusTraversal.html)

<!-- dummy comment line for breaking list -->

### コメント
