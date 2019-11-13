---
layout: post
category: swing
folder: FocusDashedRectGap
title: JButtonなどの点線によるフォーカス描画の内余白を変更する
tags: [JButton, JToggleButton, JRadioButton, JCheckBox, LookAndFeel, UIManager, Focus]
author: aterai
pubdate: 2019-11-11T16:45:31+09:00
description: WindowsLookAndFeelなどを適用したJButtonで描画される点線によるフォーカス矩形の内余白を変更します。
image: https://drive.google.com/uc?id=1l5MNuTp7CTOcdF6t6zeqccxU2fJtnU6V
comments: true
---
## 概要
`WindowsLookAndFeel`などを適用した`JButton`で描画される点線によるフォーカス矩形の内余白を変更します。

{% download https://drive.google.com/uc?id=1l5MNuTp7CTOcdF6t6zeqccxU2fJtnU6V %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("Button.dashedRectGapX", 5);
UIManager.put("Button.dashedRectGapY", 5);
UIManager.put("Button.dashedRectGapWidth", 10);
UIManager.put("Button.dashedRectGapHeight", 10);
</code></pre>

## 解説
- `JButton`
    - `BasicGraphicsUtils.drawDashedRect(g, dashedRectGapX, dashedRectGapY, width - dashedRectGapWidth, height - dashedRectGapHeight);`で点線によるフォーカス矩形の内余白を変更可能
    - `WindowsLookAndFeel`でのデフォルトは`dashedRectGapX: 3`、`dashedRectGapY: 3`、`dashedRectGapWidth: 6`、`dashedRectGapHeight: 6`
    - `MetalLookAndFeel`、`NimbusLookAndFeel`などでは効果なし
    - このサンプルでは`UIManager.put("Button.margin", new Insets(8, 8, 8, 8))`でボタンの内余白を設定しているが、これは点線によるフォーカス矩形の内余白には影響しない
    - `dashedRectGapWidth`は`dashedRectGapX`の二倍になるよう設定しないとバランスが崩れる
- `JToggleButton`
    - `ToggleButton.dashedRectGapX`などは存在しないが、`Button.dashedRectGapX`の値が適用される
- `RadioButton`
    - `RadioButton.dashedRectGapX`などは存在しない
    - `WindowsRadioButtonUI`のソースコードでは`Button.dashedRectGapX`の値が読み込まれているが、実際にはどこにも使用されていない
    - `html`の`td`要素に`padding`属性を設定すると点線によるフォーカス矩形の内余白を変更可能
        - 例: `new JRadioButton("<html><table><td style='padding:1'>JRadioButton...")`
- `JCheckBox`
    - `CheckBox.dashedRectGapX`などは存在しない
    - `html`の`td`要素に`padding`属性を設定すると点線によるフォーカス矩形の内余白を変更可能

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTreeのノードの文字列に余白を追加](https://ateraimemo.com/Swing/TreeCellMargin.html)
    - `JTree`のノードに描画される点線によるフォーカス矩形の内余白を変更
- [JComboBoxのFocusBorderの対象を内部のアイテムではなくJComboBox自体に変更する](https://ateraimemo.com/Swing/ComboBoxFocusBorder.html)
- [JSliderのFocusBorderを非表示に設定する](https://ateraimemo.com/Swing/SliderFocusBorder.html)

<!-- dummy comment line for breaking list -->

## コメント
