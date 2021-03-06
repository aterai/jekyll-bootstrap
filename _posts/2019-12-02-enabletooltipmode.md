---
layout: post
category: swing
folder: EnableToolTipMode
title: JToolTipの表示をウィンドウが非アクティブな場合でも有効にする
tags: [JToolTip, ToolTipManager, UIManager]
author: aterai
pubdate: 2019-12-02T14:46:11+09:00
description: JToolTipの表示モードをすべてのウィンドウで有効にする、またはアクティブなウィンドウのみに限定するで切り替えます。
image: https://drive.google.com/uc?id=1Fpl-P9uPOWTn4O-9Xy0pbWKQZIevg_VT
comments: true
---
## 概要
`JToolTip`の表示モードをすべてのウィンドウで有効にする、またはアクティブなウィンドウのみに限定するで切り替えます。

{% download https://drive.google.com/uc?id=1Fpl-P9uPOWTn4O-9Xy0pbWKQZIevg_VT %}

## サンプルコード
<pre class="prettyprint"><code>private static final String TOOLTIP_MODE = "ToolTipManager.enableToolTipMode";
// ...
String allWindows = "allWindows";
JRadioButton radio1 = new JRadioButton(allWindows, Objects.equals(allWindows, mode));
radio1.setToolTipText("ToolTip: " + allWindows);
radio1.addItemListener(e -&gt; UIManager.put(TOOLTIP_MODE, allWindows));

String activeApplication = "activeApplication";
JRadioButton radio2 = new JRadioButton(activeApplication, Objects.equals(activeApplication, mode));
radio2.setToolTipText("ToolTip: " + activeApplication);
radio2.addItemListener(e -&gt; UIManager.put(TOOLTIP_MODE, activeApplication));
</code></pre>

## 解説
- `allWindows`
    - `JFrame`などのウィンドウがアクティブかどうかにかかわらず、ツールチップは有効
    - デフォルトはこの`allWindows`で`BasicLookAndFeel`などの初期値
- `activeApplication`
    - `JFrame`などのウィンドウがアクティブな場合のみ、ツールチップは有効
    - `MetalLookAndFeel`と`WindowsLookAndFeel`の初期値

<!-- dummy comment line for breaking list -->

- - - -
- ツールチップを表示する前に`ToolTipManager#showTipWindow()`メソッド内で毎回`UIManager.getString("ToolTipManager.enableToolTipMode")`が`activeApplication`かを確認しているので、値の変更はすぐに有効になる
- 文字列が`activeApplication`かを比較しているだけなので、`null`などを設定するとデフォルトの`allWindows`になる

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>// @see javax/swing/ToolTipManager.java
String mode = UIManager.getString("ToolTipManager.enableToolTipMode");
if ("activeApplication".equals(mode)) {
  KeyboardFocusManager kfm = KeyboardFocusManager.getCurrentKeyboardFocusManager();
  if (kfm.getFocusedWindow() == null) {
    return;
  }
}
</code></pre>

## 参考リンク
- [&#91;JDK-6529793&#93; Swing's default behavior should be to display tooltips when window lacks focus. - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-6529793)

<!-- dummy comment line for breaking list -->

## コメント
