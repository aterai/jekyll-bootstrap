---
layout: post
category: swing
folder: ButtonsInListCell
title: JListのセル内にJButtonを配置する
tags: [JList, JButton, ListCellRenderer]
author: aterai
pubdate: 2011-10-03T14:43:12+09:00
description: JListのセル内に複数のJButtonを配置します。
image: https://lh3.googleusercontent.com/-j4_Xv9F17Jc/TolDAZSkQUI/AAAAAAAABDU/GK_sK9k5aJE/s800/ButtonsInListCell.png
comments: true
---
## 概要
`JList`のセル内に複数の`JButton`を配置します。

{% download https://lh3.googleusercontent.com/-j4_Xv9F17Jc/TolDAZSkQUI/AAAAAAAABDU/GK_sK9k5aJE/s800/ButtonsInListCell.png %}

## サンプルコード
<pre class="prettyprint"><code>class ButtonsRenderer&lt;E&gt; extends JPanel implements ListCellRenderer&lt;E&gt; {
  protected static final Color EVEN_COLOR = new Color(0xE6_FF_E6);
  protected final JTextArea textArea = new JTextArea();
  protected final JButton deleteButton = new JButton("delete");
  protected final JButton copyButton = new JButton("copy");
  protected final List&lt;JButton&gt; buttons = Arrays.asList(deleteButton, copyButton);
  protected final DefaultListModel&lt;E&gt; model;
  protected int targetIndex;
  protected int pressedIndex = -1;
  protected int rolloverIndex = -1;
  protected JButton button;

  protected ButtonsRenderer(DefaultListModel&lt;E&gt; model) {
    super(new BorderLayout()); // *1
    this.model = model;
    setBorder(BorderFactory.createEmptyBorder(5, 5, 5, 0));
    setOpaque(true);
    textArea.setLineWrap(true);
    textArea.setOpaque(false);
    add(textArea);

    deleteButton.addActionListener(e -&gt; {
      boolean isMoreThanOneItem = model.getSize() &gt; 1;
      if (isMoreThanOneItem) {
        model.remove(targetIndex);
      }
    });
    copyButton.addActionListener(e -&gt; model.add(targetIndex, model.get(targetIndex)));

    Box box = Box.createHorizontalBox();
    buttons.forEach(b -&gt; {
      b.setFocusable(false);
      b.setRolloverEnabled(false);
      box.add(b);
      box.add(Box.createHorizontalStrut(5));
    });
    add(box, BorderLayout.EAST);
  }

  @Override public Dimension getPreferredSize() {
    Dimension d = super.getPreferredSize();
    d.width = 0; // VerticalScrollBar as needed
    return d;
  }

  @Override public Component getListCellRendererComponent(
      JList&lt;? extends E&gt; list, E value, int index,
      boolean isSelected, boolean cellHasFocus) {
    textArea.setText(Objects.toString(value, ""));
    this.targetIndex = index;
    if (isSelected) {
      setBackground(list.getSelectionBackground());
      textArea.setForeground(list.getSelectionForeground());
    } else {
      setBackground(index % 2 == 0 ? EVEN_COLOR : list.getBackground());
      textArea.setForeground(list.getForeground());
    }
    buttons.forEach(ButtonsRenderer::resetButtonStatus);
    if (Objects.nonNull(button)) {
      if (index == pressedIndex) {
        button.getModel().setSelected(true);
        button.getModel().setArmed(true);
        button.getModel().setPressed(true);
      } else if (index == rolloverIndex) {
        button.getModel().setRollover(true);
      }
    }
    return this;
  }

  private static void resetButtonStatus(AbstractButton button) {
    ButtonModel model = button.getModel();
    model.setRollover(false);
    model.setArmed(false);
    model.setPressed(false);
    model.setSelected(false);
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JList`のセルに`2`つの`JButton`を配置する`ListCellRenderer`を設定しています。
`JButton`のクリックイベントは、`JList`本体に追加したマウスリスナーで`SwingUtilities.getDeepestComponentAt(...)`を使用して`ListCellRenderer`から対象の`JButton`を取得し、`JButton#doClick()`を呼び出しています。

## 参考リンク
- [JTableのセルに複数のJButtonを配置する](https://ateraimemo.com/Swing/MultipleButtonsInTableCell.html)

<!-- dummy comment line for breaking list -->

## コメント
- ダミーの`view, edit`ボタンを実際に動作する行の`delete, copy`ボタンに変更(ソースを修正したのは`2011-10-??`、スクリーンショットは未変更)。 -- *aterai* 2013-11-20 (水) 16:13:40
- `VerticalScrollBar`が表示されると、セルの幅が縮むように変更。 -- *aterai* 2016-04-19 (火) 16:13:40

<!-- dummy comment line for breaking list -->
