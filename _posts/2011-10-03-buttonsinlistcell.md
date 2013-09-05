---
layout: post
title: JListのセル内にJButtonを配置する
category: swing
folder: ButtonsInListCell
tags: [JList, JButton, ListCellRenderer]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-10-03

## JListのセル内にJButtonを配置する
`JList`のセル内に複数の`JButton`を配置します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/-j4_Xv9F17Jc/TolDAZSkQUI/AAAAAAAABDU/GK_sK9k5aJE/s800/ButtonsInListCell.png)

### サンプルコード
<pre class="prettyprint"><code>class ButtonsRenderer extends JPanel implements ListCellRenderer {
  public JTextArea label = new JTextArea();
  private final JButton viewButton = new JButton(new AbstractAction("view") {
    @Override public void actionPerformed(ActionEvent e) {
      System.out.println("aaa");
    }
  });
  private final JButton editButton = new JButton(new AbstractAction("edit") {
    @Override public void actionPerformed(ActionEvent e) {
      System.out.println("bbb");
    }
  });
  public ButtonsRenderer() {
    super(new BorderLayout());
    setBorder(BorderFactory.createEmptyBorder(5,5,5,0));
    setOpaque(true);
    label.setLineWrap(true);
    label.setOpaque(false);
    add(label);

    Box box = Box.createHorizontalBox();
    for(JButton b: java.util.Arrays.asList(viewButton, editButton)) {
      b.setFocusable(false);
      b.setRolloverEnabled(false);
      box.add(b);
      box.add(Box.createHorizontalStrut(5));
    }
    add(box, BorderLayout.EAST);
  }
  private final Color evenColor = new Color(230,255,230);
  @Override public Component getListCellRendererComponent(
      JList list, Object value, int index, boolean isSelected, boolean hasFocus) {
    label.setText((value==null)?"":value.toString());
    if(isSelected) {
      setBackground(list.getSelectionBackground());
      label.setForeground(list.getSelectionForeground());
    }else{
      setBackground(index%2==0 ? evenColor : list.getBackground());
      label.setForeground(list.getForeground());
    }
    for(JButton b: java.util.Arrays.asList(viewButton, editButton)) {
      b.getModel().setRollover(false);
      b.getModel().setArmed(false);
      b.getModel().setPressed(false);
      b.getModel().setSelected(false);
    }
    if(button!=null) {
      if(index==pressedIndex) {
        button.getModel().setSelected(true);
        button.getModel().setArmed(true);
        button.getModel().setPressed(true);
      }else if(index==rolloverIndex) {
        button.getModel().setRollover(true);
      }
    }
    return this;
  }
  public int pressedIndex  = -1;
  public int rolloverIndex = -1;
  public JButton button = null;
}
</code></pre>

### 解説
上記のサンプルでは、`JList`のセルに`2`つの`JButton`を配置する`ListCellRenderer`を設定しています。
`JButton`のクリックイベントは、`JList`に追加したマウスリスナーで`SwingUtilities.getDeepestComponentAt(...)`を使用して対象の`JButton`を取得し、`JButton#doClick()`を呼び出すようになっています。

### 参考リンク
- [JTableのセルに複数のJButtonを配置する](http://terai.xrea.jp/Swing/MultipleButtonsInTableCell.html)

<!-- dummy comment line for breaking list -->

### コメント