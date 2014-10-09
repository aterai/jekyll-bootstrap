---
layout: post
category: swing
folder: ClippedLRComboBox
title: JComboBoxのItemを左右にクリップして配置
tags: [JComboBox, ListCellRenderer, JLabel, JPanel]
author: aterai
pubdate: 2005-09-12T13:00:56+09:00
description: JComboBoxのItemにテキストをクリップして左右に分けて配置します。
comments: true
---
## 概要
`JComboBox`の`Item`にテキストをクリップして左右に分けて配置します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTJSTVvNXI/AAAAAAAAAUI/RNbSh6R4xi8/s800/ClippedLRComboBox.png %}

## サンプルコード
<pre class="prettyprint"><code>class MultiColumnCellRenderer extends JPanel implements ListCellRenderer{
  private final JLabel leftLabel = new JLabel();
  private final JLabel rightLabel;

  public MultiColumnCellRenderer(int rightWidth) {
    super(new BorderLayout());
    this.setBorder(BorderFactory.createEmptyBorder(1,1,1,1));

    leftLabel.setOpaque(false);
    leftLabel.setBorder(BorderFactory.createEmptyBorder(0,2,0,0));

    final Dimension dim = new Dimension(rightWidth, 0);
    rightLabel = new JLabel() {
      @Override public Dimension getPreferredSize() {
        return dim;
      }
    };
    rightLabel.setOpaque(false);
    rightLabel.setBorder(BorderFactory.createEmptyBorder(0,2,0,2));
    rightLabel.setForeground(Color.GRAY);
    rightLabel.setHorizontalAlignment(SwingConstants.RIGHT);

    this.add(leftLabel);
    this.add(rightLabel, BorderLayout.EAST);
  }
  @Override public Component getListCellRendererComponent(
      JList list, Object value, int index,
      boolean isSelected, boolean cellHasFocus) {
    LRItem item = (LRItem)value;
    leftLabel.setText(item.getLeftText());
    rightLabel.setText(item.getRightText());

    leftLabel.setFont(list.getFont());
    rightLabel.setFont(list.getFont());

    if(index&lt;0) {
      leftLabel.setForeground(list.getForeground());
      this.setOpaque(false);
    }else{
      leftLabel.setForeground(
          isSelected?list.getSelectionForeground():list.getForeground());
      this.setBackground(
          isSelected?list.getSelectionBackground():list.getBackground());
      this.setOpaque(true);
    }
    return this;
  }
  @Override public Dimension getPreferredSize() {
    Dimension d = super.getPreferredSize();
    return new Dimension(0, d.height);
  }
  @Override public void updateUI() {
    super.updateUI();
    this.setName("List.cellRenderer");
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JLabel`を二つ並べた`JPanel`をレンダラーにすることで、`Item`に設定した文字列を左右に表示しています。このため文字列が長い場合、`JLabel`がこれを自動的にクリップしてくれます。

## 参考リンク
- [JComboBoxのItemを左右に配置](http://terai.xrea.jp/Swing/LRComboBox.html)
    - こちらは`html`の`table`タグを使用して同様の表示(クリップはしない)を行っています。

<!-- dummy comment line for breaking list -->

## コメント
- ポップアップリストが更新されなくなって？、うまくクリップできなくなっていたのを修正。 -- *aterai* 2008-08-13 (水) 15:14:12
- 選択時の文字色を修正(`Windows 7`などへの対応)。 -- *aterai* 2012-02-03 (金) 14:28:48

<!-- dummy comment line for breaking list -->
