---
layout: post
category: swing
folder: FloatingToolBarStartingLocation
title: JToolBarが起動時に指定した位置でフローティング状態になるよう設定する
tags: [JToolBar, Window]
author: aterai
pubdate: 2017-01-23T00:05:35+09:00
description: アプリケーションを起動した時、JToolBarが指定した位置にフローティング状態で配置されるように設定します。
image: https://drive.google.com/uc?id=1PLQTp9ryyxO5K8UZUj2gL_nn_wp4x66XQA
comments: true
---
## 概要
アプリケーションを起動した時、`JToolBar`が指定した位置にフローティング状態で配置されるように設定します。

{% download https://drive.google.com/uc?id=1PLQTp9ryyxO5K8UZUj2gL_nn_wp4x66XQA %}

## サンプルコード
<pre class="prettyprint"><code> EventQueue.invokeLater(() -&gt; {
  Container w = getTopLevelAncestor();
  if (w instanceof Window) {
    Point pt = ((Window) w).getLocation();
    BasicToolBarUI ui = (BasicToolBarUI) toolbar.getUI();
    ui.setFloatingLocation(pt.x + 120, pt.y + 160);
    ui.setFloating(true, null);
  }
});
</code></pre>

## 解説
上記のサンプルでは、アプリケーションを起動した時点で`JToolBar`がフローティング状態になるように設定し、その表示位置を指定しています。

- `BasicToolBarUI#setFloating(boolean, Point)`メソッドの引数`Point`は、引数`boolean`が`false`の場合のみ`BorderLayout`の東西南北どの位置にドックするかを調査するために使用される
    - 参考: [java - Setting a specific location for a floating JToolBar - Stack Overflow](https://stackoverflow.com/questions/41701664/setting-a-specific-location-for-a-floating-jtoolbar)
    - `true`でフローティング状態に移行する場合、引数`Point`は使用されないので何を指定しても無効
    - このため、`JToolBar`をフローティング状態に移行する前に`BasicToolBarUI#setFloatingLocation(...)`でその位置を指定しておく必要がある
- フローティング状態の`JToolBar`から親`Window`を取得し、直接`Window#setLocation(...)`でその位置を指定する方法もある

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>// ドッキング元のメインWindow
Window w = (Window) getTopLevelAncestor();
Point pt = w.getLocation();
// フローティング状態に移行
((BasicToolBarUI) toolbar.getUI()).setFloating(true, null);
// JToolBar(フローティング状態)のWindow
Container c = toolbar.getTopLevelAncestor();
if (c instanceof Window) {
  ((Window) c).setLocation(pt.x + 120, pt.y + 160);
}
</code></pre>

## 参考リンク
- [java - Setting a specific location for a floating JToolBar - Stack Overflow](https://stackoverflow.com/questions/41701664/setting-a-specific-location-for-a-floating-jtoolbar)
- [JToolBarをドラッグによる移動は可能だが分離は不可に設定する](https://ateraimemo.com/Swing/NonDetachableToolBar.html)
- [BasicToolBarUI#setFloatingLocation(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/plaf/basic/BasicToolBarUI.html#setFloatingLocation-int-int-)
    - 現在の`BasicToolBarUI#setFloatingLocation(...)`や`setFloating(...)`のドキュメントは空なので、詳細が知りたい場合は、ソースコードを参照する必要がある

<!-- dummy comment line for breaking list -->

## コメント
