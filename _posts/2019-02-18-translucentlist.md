---
layout: post
category: swing
folder: TranslucentList
title: JListの選択色を半透明に設定する
tags: [JList, ListCellRenderer, JScrollPane, JViewport]
author: aterai
pubdate: 2019-02-18T17:02:30+09:00
description: JListの選択色を半透明に設定、また背景色を透明にして親パネルの背景を透かして表示します。
image: https://drive.google.com/uc?id=1vKNT9-SB-DsPrTxPEVYwq8FHoKQ97DYZog
comments: true
---
## 概要
`JList`の選択色を半透明に設定、また背景色を透明にして親パネルの背景を透かして表示します。

{% download https://drive.google.com/uc?id=1vKNT9-SB-DsPrTxPEVYwq8FHoKQ97DYZog %}

## サンプルコード
<pre class="prettyprint"><code>JList&lt;ListItem&gt; list = new RubberBandSelectionList&lt;&gt;(model);
list.setOpaque(false);
list.setBackground(new Color(0x0, true));
list.setForeground(Color.WHITE);
// list.addListSelectionListener(e -&gt; {
//   SwingUtilities.getUnwrappedParent((Component) e.getSource()).repaint();
// });

JScrollPane scroll = new JScrollPane(list);
scroll.setBackground(new Color(0x0, true));
scroll.setOpaque(false);
scroll.setBorder(BorderFactory.createEmptyBorder());
scroll.setViewportBorder(BorderFactory.createEmptyBorder());
scroll.getViewport().setOpaque(false);
// scroll.getViewport().addChangeListener(e -&gt; ((Component) e.getSource()).repaint());

JPanel panel = new JPanel(new BorderLayout()) {
  private final TexturePaint texture = TextureUtils.createCheckerTexture(6);
  @Override public void paintComponent(Graphics g) {
    Graphics2D g2 = (Graphics2D) g.create();
    g2.setPaint(texture);
    g2.fillRect(0, 0, getWidth(), getHeight());
    g2.dispose();
    super.paintComponent(g);
  }
};
panel.setBackground(Color.GREEN);
panel.setOpaque(false);
panel.add(scroll);

// ...
class ListItemListCellRenderer&lt;E extends ListItem&gt; implements ListCellRenderer&lt;E&gt; {
  protected static final Color SELECTED_COLOR = new Color(50, 100, 255, 64);
  private final JLabel label = new JLabel("", (Icon) null, SwingConstants.CENTER) {
    @Override protected void paintComponent(Graphics g) {
      super.paintComponent(g);
      if (SELECTED_COLOR.equals(getBackground())) {
        Graphics2D g2 = (Graphics2D) g.create();
        g2.setPaint(SELECTED_COLOR);
        g2.fillRect(0, 0, getWidth(), getHeight());
        g2.dispose();
      }
    }
  };
  private final JPanel renderer = new JPanel(new BorderLayout());
  private final Border focusBorder = UIManager.getBorder("List.focusCellHighlightBorder");
  private final Border noFocusBorder; // = UIManager.getBorder("List.noFocusBorder");

  protected ListItemListCellRenderer() {
    Border b = UIManager.getBorder("List.noFocusBorder");
    if (Objects.isNull(b)) { // Nimbus???
      Insets i = focusBorder.getBorderInsets(renderer);
      b = BorderFactory.createEmptyBorder(i.top, i.left, i.bottom, i.right);
    }
    noFocusBorder = b;
    label.setVerticalTextPosition(SwingConstants.BOTTOM);
    label.setHorizontalTextPosition(SwingConstants.CENTER);
    label.setForeground(renderer.getForeground());
    label.setBackground(renderer.getBackground());
    label.setBorder(noFocusBorder);
    label.setOpaque(false);
    renderer.setBorder(BorderFactory.createEmptyBorder(2, 2, 2, 2));
    renderer.add(label);
    renderer.setOpaque(false);
  }

  @Override public Component getListCellRendererComponent(
      JList&lt;? extends E&gt; list, E value, int index,
      boolean isSelected, boolean cellHasFocus) {
    label.setText(value.title);
    label.setBorder(cellHasFocus ? focusBorder : noFocusBorder);
    label.setIcon(value.icon);
    if (isSelected) {
      label.setForeground(list.getSelectionForeground());
      label.setBackground(SELECTED_COLOR);
    } else {
      label.setForeground(list.getForeground());
      label.setBackground(list.getBackground());
    }
    return renderer;
  }
}
</code></pre>

## 解説
- `JList`、`JScrollPane`にアルファ値`0`で完全に透明な背景色を設定
- `JList`、`JScrollPane`、`JViewport`を`setOpaque(false)`で透明化
    - `JList`を`setOpaque(true)`で不透明化した場合、`ListSelectionListener`などで選択が変更されたら再描画する必要がある
    - `JViewport`を`setOpaque(true)`で不透明化した場合、`ChangeListener`でスクロールが発生したら再描画する必要がある
- `ListCellRenderer`を`setOpaque(false)`で透明化
    - `ListCellRenderer`の選択色を`paintComponent(...)`メソッドをオーバーライドして半透明で描画

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JListのアイテムを範囲指定で選択](https://ateraimemo.com/Swing/RubberBanding.html)
    - 半透明の矩形選択はこちらのサンプルを参考
- [JTableのヘッダを透明化](https://ateraimemo.com/Swing/TransparentTableHeader.html)
    - セル選択の半透明化はこちらの`JTable`のサンプルを参考

<!-- dummy comment line for breaking list -->

## コメント
