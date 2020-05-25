---
layout: post
category: swing
folder: RoundedScrollPane
title: JScrollPaneの角を丸める
tags: [JScrollPane, Border, JComboBox]
author: aterai
pubdate: 2020-05-18T15:10:30+09:00
description: JScrollPaneに角丸表示をおこなうためのBorderを設定します。
image: https://drive.google.com/uc?id=1po7Hxu9X7xIcMO6Vs6YOZkzbZmMqyrN3
comments: true
---
## 概要
`JScrollPane`に角丸表示をおこなうための`Border`を設定します。

{% download https://drive.google.com/uc?id=1po7Hxu9X7xIcMO6Vs6YOZkzbZmMqyrN3 %}

## サンプルコード
<pre class="prettyprint"><code>JScrollPane scroll = new JScrollPane(tree) {
  @Override public void updateUI() {
    super.updateUI();
    getVerticalScrollBar().setUI(new WithoutArrowButtonScrollBarUI());
    getHorizontalScrollBar().setUI(new WithoutArrowButtonScrollBarUI());
  }
};
scroll.setBackground(tree.getBackground());
scroll.setBorder(new RoundedCornerBorder());
</code></pre>

## 解説
- `JScrollPane`
    - `JScrollPane`に`RoundedCornerBorder`を設定して角を丸める
    - `JScrollPane`の背景色を内部に配置したコンポーネントの背景色と同じ色に変更
    - `JScrollBar`の角を丸めて矢印ボタンを非表示化
    - 参考: [JTextFieldの角を丸める](https://ateraimemo.com/Swing/RoundedTextField.html)
- `JComboBox`
    - ドロップダウンリストに使用される`JScrollPane`ではなく`JPopupMenu`に`BottomRoundedCornerBorder`を設定
        - 直接`JScrollPane`に`BottomRoundedCornerBorder`を設定しても無効？
    - `BasicComboPopup#createScroller()`をオーバーライドし`JScrollBar`の角を丸めて矢印ボタンを非表示化
    - 参考: [JComboBoxの角を丸める](https://ateraimemo.com/Swing/RoundedComboBox.html)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>JComboBox&lt;String&gt; combo = new JComboBox&lt;String&gt;(makeModel()) {
  private transient MouseListener handler;
  private transient PopupMenuListener listener;
  @Override public void updateUI() {
    removeMouseListener(handler);
    removePopupMenuListener(listener);
    UIManager.put(KEY, new TopRoundedCornerBorder());
    super.updateUI();
    setUI(new BasicComboBoxUI() {
      @Override protected JButton createArrowButton() {
        JButton b = new JButton(new ArrowIcon(BACKGROUND, FOREGROUND));
        b.setContentAreaFilled(false);
        b.setFocusPainted(false);
        b.setBorder(BorderFactory.createEmptyBorder());
        return b;
      }

      @Override protected ComboPopup createPopup() {
        return new BasicComboPopup(comboBox) {
          @Override protected JScrollPane createScroller() {
            JScrollPane sp = new JScrollPane(list) {
              @Override public void updateUI() {
                super.updateUI();
                getVerticalScrollBar().setUI(new WithoutArrowButtonScrollBarUI());
                getHorizontalScrollBar().setUI(new WithoutArrowButtonScrollBarUI());
              }
            };
            sp.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_AS_NEEDED);
            sp.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);
            sp.setHorizontalScrollBar(null);
            return sp;
          }
        };
      }
    });
    handler = new ComboRolloverHandler();
    addMouseListener(handler);
    listener = new HeavyWeightContainerListener();
    addPopupMenuListener(listener);
    Object o = getAccessibleContext().getAccessibleChild(0);
    if (o instanceof JComponent) {
      JComponent c = (JComponent) o;
      c.setBorder(new BottomRoundedCornerBorder());
      c.setForeground(FOREGROUND);
      c.setBackground(BACKGROUND);
    }
  }
};
</code></pre>

## 参考リンク
- [JTextFieldの角を丸める](https://ateraimemo.com/Swing/RoundedTextField.html)
- [JComboBoxの角を丸める](https://ateraimemo.com/Swing/RoundedComboBox.html)
- [JScrollBarのArrowButtonを非表示にする](https://ateraimemo.com/Swing/ArrowButtonlessScrollBar.html)

<!-- dummy comment line for breaking list -->

## コメント
