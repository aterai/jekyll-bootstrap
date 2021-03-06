---
layout: post
category: swing
folder: ButtonsInMenuItem
title: JMenuItemの内部にJButtonを配置する
tags: [JMenuItem, JButton, GridBagLayout, JLayer]
author: aterai
pubdate: 2013-11-25T00:04:55+09:00
description: JMenuItemの内部に切り取り、コピー、貼り付けを行うJButtonを配置します。
image: https://lh6.googleusercontent.com/-aY1o9VhHFWI/UpHzycRD8gI/AAAAAAAAB64/jaFbU_zn7hI/s800/ButtonsInMenuItem.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2013/11/cut-copy-paste-buttuns-in-jmenuitem.html
    lang: en
comments: true
---
## 概要
`JMenuItem`の内部に切り取り、コピー、貼り付けを行う`JButton`を配置します。

{% download https://lh6.googleusercontent.com/-aY1o9VhHFWI/UpHzycRD8gI/AAAAAAAAB64/jaFbU_zn7hI/s800/ButtonsInMenuItem.png %}

## サンプルコード
<pre class="prettyprint"><code>private static JMenuItem makeEditMenuItem(final JComponent edit) {
  JMenuItem item = new JMenuItem("Edit") {
    @Override public Dimension getPreferredSize() {
      Dimension d = super.getPreferredSize();
      d.width += edit.getPreferredSize().width;
      d.height = Math.max(edit.getPreferredSize().height, d.height);
      return d;
    }
    @Override protected void fireStateChanged() {
      setForeground(Color.BLACK);
      super.fireStateChanged();
    }
  };
  item.setEnabled(false);

  GridBagConstraints c = new GridBagConstraints();
  item.setLayout(new GridBagLayout());
  c.anchor  = GridBagConstraints.LINE_END;
  c.weightx = 1d;

  c.fill = GridBagConstraints.HORIZONTAL;
  item.add(Box.createHorizontalGlue(), c);
  c.fill = GridBagConstraints.NONE;
  item.add(edit, c);

  return item;
}
private static JPanel makeEditButtonBar(List&lt;AbstractButton&gt; list) {
  int size = list.size();
  JPanel p = new JPanel(new GridLayout(1, size, 0, 0)) {
    @Override public Dimension getMaximumSize() {
      return super.getPreferredSize();
    }
  };
  for (AbstractButton b: list) {
    b.setIcon(new ToggleButtonBarCellIcon());
    p.add(b);
  }
  p.setBorder(BorderFactory.createEmptyBorder(4, 10, 4, 10));
  p.setOpaque(false);
  return p;
}
private static AbstractButton makeButton(String title, Action action) {
  JButton b = new JButton(action);
  b.addActionListener(new ActionListener() {
    @Override public void actionPerformed(ActionEvent e) {
      JButton b = (JButton) e.getSource();
      Container c = SwingUtilities.getAncestorOfClass(JPopupMenu.class, b);
      if (c instanceof JPopupMenu) {
        ((JPopupMenu) c).setVisible(false);
      }
    }
  });
  b.setText(title);
  b.setVerticalAlignment(SwingConstants.CENTER);
  b.setVerticalTextPosition(SwingConstants.CENTER);
  b.setHorizontalAlignment(SwingConstants.CENTER);
  b.setHorizontalTextPosition(SwingConstants.CENTER);
  b.setBorder(BorderFactory.createEmptyBorder());
  b.setContentAreaFilled(false);
  b.setFocusPainted(false);
  b.setOpaque(false);
  b.setBorder(BorderFactory.createEmptyBorder());
  return b;
}
</code></pre>

## 解説
- `JMenuItem`
    - `JMenuItem#getPreferredSize()`をオーバーライドして、挿入する`JButton`を考慮したサイズを返すように変更
    - `JMenuItem`自体は、選択不可になるように`JMenuItem#setEnabled(false)`を設定
        - `JMenuItem#setEnabled(false)`の状態でも文字色は常に黒になるように、`JMenuItem#fireStateChanged`をオーバーライドして`setForeground(Color.BLACK);`を設定
        - [JRadioButtonの文字色を変更](https://ateraimemo.com/Swing/RadioButtonTextColor.html)
    - `JMenuItem`にレイアウトを設定し、`JMenuItem#add(...)`で`JButton`を配置した`JPanel`を追加
        - [OverlayLayoutの使用](https://ateraimemo.com/Swing/OverlayLayout.html)
        - レイアウトマネージャーは`GridBagLayout`を使用し、追加する`JButton`は左右は右端、上下は中央になるよう設定
        - [GridBagLayoutの使用](https://ateraimemo.com/Swing/GridBagLayout.html)
- `JPanel`(`JMenuItem`内に右揃えで配置)
    - レイアウトを`GridLayout`に変更して同じサイズの`JButton`を複数配置
    - `JPanel#getMaximumSize()`をオーバーライドして、`JPanel#getPreferredSize()`と同じサイズを返すよう変更
    - [JButtonの高さを変更せずに幅を指定](https://ateraimemo.com/Swing/ButtonWidth.html)
- `JButton`(`JPanel`内に`3`個同幅で配置)
    - `DefaultEditorKit.CopyAction()`などで、`Action`を設定
    - 左右両端に配置された`JButton`のフチのラウンドなどは、`Icon`を生成して描画
        - [JRadioButtonを使ってToggleButtonBarを作成](https://ateraimemo.com/Swing/ToggleButtonBar.html)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Custom JMenuItems in Java](https://stackoverflow.com/questions/5972368/custom-jmenuitems-in-java)
- [JPopupMenuのレイアウトを変更して上部にメニューボタンを追加する](https://ateraimemo.com/Swing/PopupMenuLayout.html)
    - こちらは`JPopupMenu`のレイアウトを変更してボタンメニューを作成している
- [DefaultEditorKit.CutAction (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/DefaultEditorKit.CutAction.html)
- [DefaultEditorKit.CopyAction (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/DefaultEditorKit.CopyAction.html)
- [DefaultEditorKit.PasteAction (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/DefaultEditorKit.PasteAction.html)

<!-- dummy comment line for breaking list -->

## コメント
