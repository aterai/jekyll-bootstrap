---
layout: post
category: swing
folder: DifferentCellHeight
title: JListで異なる高さのセルを使用
tags: [JList, JTextArea, ListCellRenderer]
author: aterai
pubdate: 2006-05-15T09:36:24+09:00
description: JListのレンダラーにJTextAreaを使って、異なる高さのセルを作成します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTK2Z8UOTI/AAAAAAAAAWo/7GoDkuVX8Fc/s800/DifferentCellHeight.png
comments: true
---
## 概要
`JList`のレンダラーに`JTextArea`を使って、異なる高さのセルを作成します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTK2Z8UOTI/AAAAAAAAAWo/7GoDkuVX8Fc/s800/DifferentCellHeight.png %}

## サンプルコード
<pre class="prettyprint"><code>class TextAreaRenderer&lt;E extends String&gt; extends JTextArea
                                         implements ListCellRenderer&lt;E&gt; {
  private static final Color EVEN_COLOR = new Color(230, 255, 230);
  private Border noFocusBorder;
  private Border focusBorder;

  @Override public Component getListCellRendererComponent(
      JList&lt;? extends E&gt; list, E value, int index,
      boolean isSelected, boolean cellHasFocus) {
    // setLineWrap(true);
    setText(Objects.toString(value, ""));
    if (isSelected) {
      // Nimbus
      setBackground(new Color(list.getSelectionBackground().getRGB()));
      setForeground(list.getSelectionForeground());
    } else {
      setBackground(index % 2 == 0 ? EVEN_COLOR : list.getBackground());
      setForeground(list.getForeground());
    }
    if (cellHasFocus) {
      setBorder(focusBorder);
    } else {
      setBorder(noFocusBorder);
    }
    return this;
  }

  @Override public void updateUI() {
    super.updateUI();
    focusBorder = UIManager.getBorder("List.focusCellHighlightBorder");
    noFocusBorder = UIManager.getBorder("List.noFocusBorder");
    if (Objects.isNull(noFocusBorder) &amp;&amp; Objects.nonNull(focusBorder)) {
      Insets i = focusBorder.getBorderInsets(this);
      noFocusBorder = BorderFactory.createEmptyBorder(
          i.top, i.left, i.bottom, i.right);
    }
  }
}

private DefaultListModel makeList() {
  DefaultListModel model = new DefaultListModel();
  model.addElement("一行");
  model.addElement("一行目\n二行目");
  model.addElement("一行目\n二行目\n三行目");
  model.addElement("四行\n以上ある\nテキスト\nの場合");
  return model;
}
</code></pre>

## 解説
- 右: デフォルトの`JList`
- 左: 複数行に対応した`JList`
    - `JList#getFixedCellHeight()`が`-1`で`ListCellRenderer`に`JTextArea`を使用しているため、テキストに`\n`を含めることで複数行が表示可能
- セルの選択状態
    - ~~`JTextArea`にセルフォーカスがある状態を表現するために`LineBorder`を継承して作成した`DotBorder`を使用~~
    - `UIManager.getBorder("List.focusCellHighlightBorder")`を使用するように変更

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JList#setFixedCellHeight(int) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JList.html#setFixedCellHeight-int-)

<!-- dummy comment line for breaking list -->

## コメント
