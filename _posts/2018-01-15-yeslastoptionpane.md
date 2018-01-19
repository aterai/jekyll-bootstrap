---
layout: post
category: swing
folder: YesLastOptionPane
title: JOptionPaneのYesボタンがCancelボタンなどの中で末尾に配置されるよう設定する
tags: [JOptionPane]
author: aterai
pubdate: 2018-01-15T14:42:52+09:00
description: JOptionPaneのYesボタンがCancelボタンなどの後に追加されて一番右に配置されるよう設定します。
image: https://drive.google.com/uc?export=view&id=12DSo9IIp_Ah9F2FlvkEjjREEwZXyNNLWhA
comments: true
---
## 概要
`JOptionPane`の`Yes`ボタンが`Cancel`ボタンなどの後に追加されて一番右に配置されるよう設定します。

{% download https://drive.google.com/uc?export=view&id=12DSo9IIp_Ah9F2FlvkEjjREEwZXyNNLWhA %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("OptionPane.isYesLast", Boolean.TRUE);
</code></pre>

## 解説
- `OptionPane.isYesLast: false(default)`
    - `Windows`環境でのデフォルトで、`Yes`ボタン(`YES_OPTION`, `OK_OPTION`)が各オプションボタンの中で先頭(左端)に配置される
    - `JOptionPane#setComponentOrientation(ComponentOrientation.RIGHT_TO_LEFT)`が設定されている場合、先頭は右端になる
- `OptionPane.isYesLast: true`
    - `Yes`ボタンが各オプションボタンの中で末尾(右端)に配置される
    - `MotifLookAndFeel`や`NimbusLookAndFeel`でもこの設定は有効
    - `JOptionPane#setComponentOrientation(ComponentOrientation.RIGHT_TO_LEFT)`が設定されている場合、末尾は左端になる

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JOptionPaneのボタンの揃えを変更する](https://ateraimemo.com/Swing/OptionPaneButtonOrientation.html)

<!-- dummy comment line for breaking list -->

## コメント
