---
layout: post
title: JMenuItemの内部にJButtonを配置する
category: swing
folder: ButtonsInMenuItem
tags: [JMenuItem, JButton, GridBagLayout, JLayer]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-11-25

## JMenuItemの内部にJButtonを配置する
`JMenuItem`の内部に切り取り、コピー、貼り付けを行う`JButton`を配置します。

{% download %}

![screenshot](https://lh6.googleusercontent.com/-aY1o9VhHFWI/UpHzycRD8gI/AAAAAAAAB64/jaFbU_zn7hI/s800/ButtonsInMenuItem.png)

### サンプルコード
<pre class="prettyprint"><code>private static JMenuItem makeEditMenuItem(final JPanel edit) {
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
  c.gridheight = 1;
  c.gridwidth  = 1;
  c.gridy = 0;
  c.gridx = 0;

  c.weightx = 1.0;
  c.fill = GridBagConstraints.HORIZONTAL;
  item.add(Box.createHorizontalGlue(), c);
  c.gridx = 1;
  c.fill = GridBagConstraints.NONE;
  c.weightx = 0.0;
  c.anchor = GridBagConstraints.EAST;
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
  for(AbstractButton b: list) {
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
      JButton b = (JButton)e.getSource();
      Container c = b.getParent().getParent().getParent();
      if(c instanceof JPopupMenu) {
        ((JPopupMenu)c).setVisible(false);
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

### 解説
- `JMenuItem`
    - `JMenuItem#getPreferredSize()`をオーバーライドして、挿入するJButtonを考慮したサイズを返すように変更
    - `JMenuItem`自体は、選択不可になるように`JMenuItemsetEnabled(false);`を設定
        - `JMenuItem#setEnabled(false);`でも文字色は常に黒になるように、`JMenuItem#fireStateChanged`をオーバーライドして`setForeground(Color.BLACK);`を設定
        - [JRadioButtonの文字色を変更](http://terai.xrea.jp/Swing/RadioButtonTextColor.html)
    - `JMenuItem`にレイアウトを設定し、`JMenuItem#add(...)`で`JButton`を配置した`JPanel`を追加
        - [OverlayLayoutの使用](http://terai.xrea.jp/Swing/OverlayLayout.html)
        - レイアウトマネージャーは、`GridBagLayout`を使用し、追加する`JButtun`は左右は右端、上下は中央に来るように設定
        - [GridBagLayoutの使用](http://terai.xrea.jp/Swing/GridBagLayout.html)
- `JPanel`
    - レイアウトを`GridLayout`に変更して同じサイズの`JButton`を複数配置
    - `JPanel#getMaximumSize()`をオーバーライドして、`JPanel#getPreferredSize()`と同じサイズを返すよう変更
    - [JButtonの高さを変更せずに幅を指定](http://terai.xrea.jp/Swing/ButtonWidth.html)
- `JButton`
    - `DefaultEditorKit.CopyAction()`などで、`Action`を設定
    - 左右両端に配置された`JButton`のフチのラウンドなどは、`Icon`を生成して描画
        - [JRadioButtonを使ってToggleButtonBarを作成](http://terai.xrea.jp/Swing/ToggleButtonBar.html)

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Custom JMenuItems in Java](http://stackoverflow.com/questions/5972368/custom-jmenuitems-in-java)

<!-- dummy comment line for breaking list -->

### コメント
