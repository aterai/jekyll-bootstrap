---
layout: post
title: JSplitPaneのDividerを展開収納するOneTouchButtonのサイズ、色などを変更
category: swing
folder: OneTouchButton
tags: [JSplitPane, SplitPaneDivider, JButton, LookAndFeel]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2014-09-08

## 概要
`JSplitPane`の`Divider`をワンクリックで展開・収納するための`OneTouchButton`のサイズ、オフセット、背景色などを変更します。

{% download https://lh4.googleusercontent.com/-_zdaiM8x6a4/VAxzwh3xxFI/AAAAAAAACM0/hBR-P4Nn56A/s800/OneTouchButton.png %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("SplitPane.oneTouchButtonSize", 32);
UIManager.put("SplitPane.oneTouchButtonOffset", 50);
//UIManager.put("SplitPane.centerOneTouchButtons", true);

UIManager.put("SplitPaneDivider.border", BorderFactory.createLineBorder(Color.RED, 10));
UIManager.put("SplitPaneDivider.draggingColor", new Color(255, 100, 100, 100));

BasicSplitPaneDivider divider = ((BasicSplitPaneUI) splitPane.getUI()).getDivider();
divider.setBackground(Color.ORANGE);
for (Component c: divider.getComponents()) {
  if (c instanceof JButton) {
    JButton b = (JButton) c;
    b.setBackground(Color.ORANGE);
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JSplitPane`の`Divider`をワンクリックで展開・収納するための`OneTouchButton`(`JButton`)のサイズ、オフセット、背景色などを変更しています。

- `OneTouchButton`のサイズ指定
    - `UIManager.put("SplitPane.oneTouchButtonSize", 32);`
    - `MetalLookAndFeel`では無効
    - `NimbusLookAndFeel`では無効で、`Divider`のサイズに依存？
- `OneTouchButton`のオフセット指定
    - `UIManager.put("oneTouchButtonOffset", 50);`
    - `JSplitPane.VERTICAL_SPLIT`の場合、`Divider`の左端から`LeftOneTouchButton`までと、`LeftOneTouchButton`と`RightOneTouchButton`までの距離が設定可能
- `OneTouchButton`の背景色
    - `JButton#paint(...)`がオーバーライドされて、`oneTouchButton.getBackground()`の色で塗り潰されている(`oneTouchButton.setOpaque(false)`で透明にしても無意味)ので、`setBackground()`で、`Divider`の背景色と同じ色を設定
        - `OneTouchButton`の図形の色と形も、`JButton#paint(...)`の中で直接描画(`Color.BLACK`固定)されているので、簡単に変更することが出来ない(`BasicSplitPaneUI`や`BasicSplitPaneDivider`をオーバーライドする必要がある)
    - `MetalLookAndFeel`、`NimbusLookAndFeel`では無効
- `OneTouchButton`の中央揃え？
    - `UIManager.put("SplitPane.centerOneTouchButtons", true);`
    - `MetalLookAndFeel`、`MotifLookAndFeel`、`WindowsLookAndFeel`、`NimbusLookAndFeel`などでは、効果が無い
- `Divider`の`Border`と、`OneTouchButton`
    - `divider.setBorder(BorderFactory.createMatteBorder(20, 0, 5, 0, Color.RED));`などを設定すると、`OneTouchButton`が`Border`にめり込んでしまう？

<!-- dummy comment line for breaking list -->

## コメント