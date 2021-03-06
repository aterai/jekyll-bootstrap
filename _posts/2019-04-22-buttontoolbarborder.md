---
layout: post
category: swing
folder: ButtonToolBarBorder
title: JToolBarに配置したボタンの縁色を設定する
tags: [JToolBar, JButton, JToggleButton, MetalLookAndFeel]
author: aterai
pubdate: 2019-04-22T14:59:07+09:00
description: JToolBarに配置したJToggleButtonやJButtonの縁色を設定します。
image: https://drive.google.com/uc?id=1jkCLCEtkxl2qq_I13YIftBgpCsXiCwkCtQ
comments: true
---
## 概要
`JToolBar`に配置した`JToggleButton`や`JButton`の縁色を設定します。

{% download https://drive.google.com/uc?id=1jkCLCEtkxl2qq_I13YIftBgpCsXiCwkCtQ %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("Button.disabledToolBarBorderBackground", Color.RED);
UIManager.put("Button.toolBarBorderBackground", Color.GREEN);
</code></pre>

## 解説
- `Button.disabledToolBarBorderBackground`:
    - `MetalLookAndFeel`を適用した`JToolBar`に配置した`setEnabled(false)`の`JToggleButton`などの縁の背景色を設定可能
    - `JToggleButton`と`JButton`には有効、`JCheckBox`と`JRadioButton`には無効
- `Button.toolBarBorderBackground`:
    - `MetalLookAndFeel`を適用した`JToolBar`に配置した`JToggleButton`などの縁の背景色を設定可能
    - ボタンが選択、またはロールオーバー状態の場合、縁の背景色はそれぞれの`Foreground`色で塗りつぶされる
    - `JToggleButton`と`JButton`には有効、`JCheckBox`と`JRadioButton`には無効
    - ボタンに独自の縁(`UIResource`を実装していない)が設定されている場合、この設定はそのボタンに対して影響しない
    
    		#
    - * 参考リンク [#reference]
- [JToolBarのロールオーバー状態を設定する](https://ateraimemo.com/Swing/RolloverModeToolBar.html)

<!-- dummy comment line for breaking list -->

## コメント
