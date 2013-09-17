---
layout: post
title: JListで異なる高さのセルを使用
category: swing
folder: DifferentCellHeight
tags: [JList, JTextArea, ListCellRenderer]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-05-15

## JListで異なる高さのセルを使用
`JList`のレンダラーに`JTextArea`を使って、異なる高さのセルを作成します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTK2Z8UOTI/AAAAAAAAAWo/7GoDkuVX8Fc/s800/DifferentCellHeight.png)

### サンプルコード
<pre class="prettyprint"><code>class TextAreaRenderer extends JTextArea implements ListCellRenderer {
  private final Border border = new DotBorder(2,2,2,2);
  private final Color evenColor = new Color(230,255,230);
  @Override public Component getListCellRendererComponent(
      JList list, Object object, int index,
      boolean isSelected, boolean cellHasFocus) {
    setText((object==null) ? "" : object.toString());
    setBorder(cellHasFocus ? border
                : BorderFactory.createEmptyBorder(2,2,2,2));
    if(isSelected) {
      setBackground(list.getSelectionBackground());
      setForeground(list.getSelectionForeground());
    }else{
      setBackground(index%2==0 ? evenColor : list.getBackground());
      setForeground(list.getForeground());
    }
    return this;
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

### 解説
左が複数行に対応した`JList`、右が通常の`JList`になります。左の`JList`では、`JList#getFixedCellHeight()`が`-1`で、`ListCellRenderer`に`JTextArea`を使用しているため、テキストに`\n`を含めることで複数行を作成することができます。

セルの区切りを分かりやすくするために、偶数奇数で行の背景色を変更しています。

`JTextArea`にセルフォーカスがある状態を表現するために、 ~~EmptyBorder~~ `LineBorder`を継承して作成した`DotBorder`を使用しています。

<pre class="prettyprint"><code>class DotBorder extends LineBorder {
  public boolean isBorderOpaque() {return true;}
  public DotBorder(Color color, int thickness) {
    super(color, thickness);
  }
  @Override public void paintBorder(
      Component c, Graphics g, int x, int y, int w, int h) {
    Graphics2D g2 = (Graphics2D)g;
    g2.translate(x,y);
    g2.setPaint(getLineColor());
    BasicGraphicsUtils.drawDashedRect(g2, 0, 0, w, h);
    g2.translate(-x,-y);
  }
}
</code></pre>

### 参考リンク
- [JList#setFixedCellHeight(int)](http://docs.oracle.com/javase/jp/6/api/javax/swing/JList.html#setFixedCellHeight%28int%29)

<!-- dummy comment line for breaking list -->

### コメント
