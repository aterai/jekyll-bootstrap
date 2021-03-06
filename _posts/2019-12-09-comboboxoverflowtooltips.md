---
layout: post
category: swing
folder: ComboBoxOverflowToolTips
title: JComboBoxで文字列が溢れる場合はJToolTipを表示可能にする
tags: [JComboBox, JToolTip, ListCellRenderer]
author: aterai
pubdate: 2019-12-09T17:24:04+09:00
description: JComboBoxのアイテム文字列がJComboBox本体またはドロップダウンリストのセルから溢れる場合のみJToolTipを表示可能に設定します。
image: https://drive.google.com/uc?id=1Gm4SDovuAp3RO8gdLagvzxvj5wComdW3
comments: true
---
## 概要
`JComboBox`のアイテム文字列が`JComboBox`本体またはドロップダウンリストのセルから溢れる場合のみ`JToolTip`を表示可能に設定します。

{% download https://drive.google.com/uc?id=1Gm4SDovuAp3RO8gdLagvzxvj5wComdW3 %}

## サンプルコード
<pre class="prettyprint"><code>private static &lt;E&gt; JComboBox&lt;E&gt; makeComboBox(ComboBoxModel&lt;E&gt; model) {
  return new JComboBox&lt;E&gt;(model) {
    @Override public void updateUI() {
      setRenderer(null);
      super.updateUI();
      ListCellRenderer&lt;? super E&gt; renderer = getRenderer();
      JComboBox&lt;E&gt; combo = this;
      JButton arrowButton = getArrowButton(this);
      setRenderer((list, value, index, isSelected, cellHasFocus) -&gt; {
        Component r = renderer.getListCellRendererComponent(
            list, value, index, isSelected, cellHasFocus);
        JComponent c = (JComponent) r;
        // Insets i1 = combo.getInsets();
        Insets ins = c.getInsets();
        // int availableWidth = combo.getWidth() - i1.top - i1.bottom - ins.top - ins.bottom;
        Rectangle rect = SwingUtilities.calculateInnerArea(combo, null);
        // System.out.println(rect);
        int availableWidth = rect.width - ins.top - ins.bottom;

        String str = Objects.toString(value, "");
        FontMetrics fm = c.getFontMetrics(c.getFont());
        c.setToolTipText(fm.stringWidth(str) &gt; availableWidth ? str : null);

        if (index &lt; 0) {
          // @see BasicComboBoxUI#rectangleForCurrentValue
          // System.out.println(UIManager.getBoolean("ComboBox.squareButton"));
          // int buttonSize = combo.getHeight() - i1.top - i1.bottom; // - ins.top - ins.bottom;
          int buttonSize = Objects.nonNull(arrowButton) ? arrowButton.getWidth() : rect.height;
          availableWidth -= buttonSize;
          JTextField tf = (JTextField) combo.getEditor().getEditorComponent();
          availableWidth -= tf.getMargin().left + tf.getMargin().right;
          combo.setToolTipText(fm.stringWidth(str) &gt; availableWidth ? str : null);
        }
        return c;
      });
    }

    private JButton getArrowButton(Container combo) {
      for (Component c: combo.getComponents()) {
        if (c instanceof JButton) {
          return (JButton) c;
        }
      }
      return null;
    }
  };
}
</code></pre>

## 解説
上記のサンプルでは、`JComboBox`の本体、またはドロップダウンリストで文字列の溢れが発生する場合のみ`JToolTip`を表示するよう`ListCellRenderer`を設定しています。

- `JComboBox`のドロップダウンリスト
    - `JComboBox`の内部ペイント領域の幅からセルレンダラーのインセットを引いた長さよりアイテム文字列の幅が短い場合に溢れが発生するので、レンダラーに`setToolTipText(...)`メソッドで省略前のアイテム文字列をツールチップ文字列として設定
- `JComboBox`の本体:
    - `JComboBox`の内部ペイント領域の幅からセルレンダラーのインセット、`ArrowButton`の幅、`EditorComponent`のインセットを引いた長さよりアイテム文字列の幅が短い場合に溢れが発生するので、`JComboBox`本体に`setToolTipText(...)`メソッドで省略前のアイテム文字列をツールチップ文字列として設定
    - `ArrowButton`の幅は、`UIManager.getBoolean("ComboBox.squareButton")`が`true`で正方形になる場合は`JComboBox`の高さから取得可能だが、このサンプルでは`JComboBox`の子`JButton`を検索して直接その幅を取得している
        - 参考: [BasicComboBoxUI#squareButton (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/plaf/basic/BasicComboBoxUI.html#squareButton)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JComboBoxの各アイテムやArrowButtonにそれぞれToolTipTextを設定する](https://ateraimemo.com/Swing/ToolTipInComboBox.html)
- [JComboBoxのアイテム文字列を左側からクリップ](https://ateraimemo.com/Swing/LeftClippedComboBox.html)
- [java - JComboBox with tooltip if display area too small, while maintaining look and feel - Stack Overflow](https://stackoverflow.com/questions/59157543/jcombobox-with-tooltip-if-display-area-too-small-while-maintaining-look-and-fee)

<!-- dummy comment line for breaking list -->

## コメント
