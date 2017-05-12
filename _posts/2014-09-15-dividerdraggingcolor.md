---
layout: post
category: swing
folder: DividerDraggingColor
title: JSplitPaneでドラッグ中のDividerの背景色を設定する
tags: [JSplitPane, Divider, UIManager]
author: aterai
pubdate: 2014-09-15T00:00:21+09:00
description: JSplitPaneのDividerがドラッグ中の場合に、その移動先を示す矩形の色を変更します。
image: https://lh5.googleusercontent.com/-M9cMsnuWpL0/VBWl0TfGYyI/AAAAAAAACNI/qvejKL7NGVk/s800/DividerDraggingColor.png
comments: true
---
## 概要
`JSplitPane`の`Divider`がドラッグ中の場合に、その移動先を示す矩形の色を変更します。

{% download https://lh5.googleusercontent.com/-M9cMsnuWpL0/VBWl0TfGYyI/AAAAAAAACNI/qvejKL7NGVk/s800/DividerDraggingColor.png %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("SplitPaneDivider.draggingColor", new Color(255, 100, 100, 100));
</code></pre>

## 解説
- `JSplitPane`の`Divider`がドラッグ中の場合、その移動先を示す矩形の色を変更: `SplitPaneDivider.draggingColor`を半透明の色に変更
    - `JSplitPane#setContinuousLayout(false)`が設定されている`JSplitPane`のみ半透明は有効
- ドラッグ中ではない`Divider`の色は、以下のような方法で変更可能
    - `LookAndFeel`に依存する
        
        <pre class="prettyprint"><code>BasicSplitPaneDivider divider = ((BasicSplitPaneUI) getUI()).getDivider();
        divider.setBackground(Color.ORANGE);
</code></pre>
    - * 参考リンク [#reference]
- [JSplitPaneでディバイダの移動を連続的に再描画](http://ateraimemo.com/Swing/ContinuousLayout.html)

<!-- dummy comment line for breaking list -->

## コメント
