---
layout: post
category: swing
folder: NonDetachableToolBar
title: JToolBarをドラッグによる移動は可能だが分離は不可に設定する
tags: [JToolBar, Window]
author: aterai
pubdate: 2015-06-01T00:19:48+09:00
description: JToolBarをドラッグで同コンテナ内で移動することは可能だが、別ウインドウへの分離は不可になるよう設定します。
image: https://lh3.googleusercontent.com/-YGC3PvuL8Vg/VWsjz3ObkoI/AAAAAAAAN5w/_XAG0E-FOpM/s800/NonDetachableToolBar.png
comments: true
---
## 概要
`JToolBar`をドラッグで同コンテナ内で移動することは可能だが、別ウインドウへの分離は不可になるよう設定します。

{% download https://lh3.googleusercontent.com/-YGC3PvuL8Vg/VWsjz3ObkoI/AAAAAAAAN5w/_XAG0E-FOpM/s800/NonDetachableToolBar.png %}

## サンプルコード
<pre class="prettyprint"><code>toolbar.setUI(new BasicToolBarUI() {
  @Override public void setFloating(boolean b, Point p) {
    super.setFloating(false, p);
  }
}
});
</code></pre>

## 解説
- `Floatable(movable)`
    - `JToolBar#setFloatable(boolean)`メソッドでマウスドラッグによる移動の可・不可を設定
    - 別ウィンドウへのドラッグアウトが不可になるだけでなく同コンテナ内での移動も不可になる
- `Floating(detachable)`
    - `BasicToolBarUI#setFloating(...)`メソッドをオーバーライドして`JToolBar`を別ウインドウに分離不可に設定
    - 別ウィンドウへのドラッグアウトは不可になるがドラッグによる同コンテナ内の移動は可能

<!-- dummy comment line for breaking list -->

## 参考リンク
- [java - Can you make a JToolBar undetachable? - Stack Overflow](https://stackoverflow.com/questions/30484769/can-you-make-a-jtoolbar-undetachable)
- [JToolBarが起動時に指定した位置でフローティング状態になるよう設定する](https://ateraimemo.com/Swing/FloatingToolBarStartingLocation.html)

<!-- dummy comment line for breaking list -->

## コメント
