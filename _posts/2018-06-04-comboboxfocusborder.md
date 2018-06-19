---
layout: post
category: swing
folder: ComboBoxFocusBorder
title: JComboBoxのFocusBorderの対象を内部のアイテムではなくJComboBox自体に変更する
tags: [JComboBox, Focus, Border, WindowsLookAndFeel]
author: aterai
pubdate: 2018-06-04T15:29:53+09:00
description: WindowsLookAndFeelでJComboBoxの内部アイテムに適用される点線のFocusBorderを非表示にし、代替としてJComboBox自体に実線のFocusBorderを表示します。
image: https://drive.google.com/uc?id=1c5v18Ay9IHqlvUQYoK72CBW4ln2OS5QXxQ
comments: true
---
## 概要
`WindowsLookAndFeel`で`JComboBox`の内部アイテムに適用される点線の`FocusBorder`を非表示にし、代替として`JComboBox`自体に実線の`FocusBorder`を表示します。

{% download https://drive.google.com/uc?id=1c5v18Ay9IHqlvUQYoK72CBW4ln2OS5QXxQ %}

## サンプルコード
<pre class="prettyprint"><code>JComboBox&lt;String&gt; combo3 = new JComboBox&lt;String&gt;(model) {
  @Override public void updateUI() {
    setRenderer(null);
    super.updateUI();
    if (isWindowsLnF()) {
      setRenderer(new DefaultListCellRenderer() {
        @Override public Component getListCellRendererComponent(
            JList&lt;?&gt; list, Object value, int index,
            boolean isSelected, boolean cellHasFocus) {
          JLabel l = (JLabel) super.getListCellRendererComponent(
              list, value, index, isSelected, cellHasFocus);
          if (index &lt; 0) {
            l.setBorder(BorderFactory.createEmptyBorder(1, 1, 1, 1));
          }
          return l;
        }
      });
    }
  }
  @Override protected void paintBorder(Graphics g) {
    super.paintBorder(g);
    if (isFocusOwner() &amp;&amp; !isPopupVisible() &amp;&amp; isWindowsLnF()) {
      Graphics2D g2 = (Graphics2D) g.create();
      g2.setPaint(Color.DARK_GRAY);
      g2.drawRect(0, 0, getWidth() - 1, getHeight() - 1);
      g2.dispose();
    }
  }
  private boolean isWindowsLnF() {
    return getUI().getClass().getName().contains("WindowsComboBoxUI");
  }
};
</code></pre>

## 解説
- `default`
    - デフォルトの`WindowsLookAndFeel`で編集不可の`JComboBox`にフォーカスがある場合、内部アイテム(セルレンダラー内部)に点線の`FocusBorder`が表示される
    - 点線と文字列の間隔が近く？、若干うるさい感じがする
        - 参考: [JTreeのノードの文字列に余白を追加](https://ateraimemo.com/Swing/TreeCellMargin.html)
- `setFocusable(false)`
    - `JComboBox#setFocusable(false)`で点線は非表示になるが、フォーカスが当たらなくなる
- `setRenderer(...)`
    - `DefaultListCellRenderer#getListCellRendererComponent(...)`メソッドをオーバーライドし、インデックスが`0`以下(`JComboBox`本体での内部アイテムの描画)の場合は空の`Border`を使用することで点線を非表示に設定
    - `WindowsLookAndFeel`以外では、内部アイテムに`FocusBorder`は付かないのでこのセルレンダラーは適用しない
    - フォーカスが当たっているかどうかが判別しづらくなる
- `paintBorder(...)`
    - 上記と同様のフォーカスがあっても点線を非表示にするセルレンダラーを適用
    - `JComboBox#paintBorder(...)`をオーバーライドして、別途`JComboBox`本体に`FocusBorder`を描画

<!-- dummy comment line for breaking list -->

- - - -
- メモ: `WindowsLookAndFeel`でも`UIManager.put("ComboBox.border", ...)`で`JComboBox`本体の`Border`を変更することは可能だが、内部アイテムに適用される`Border`を変更する方法は現状では存在しない？

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>UIManager.put("ComboBox.border", new LineBorder(Color.GRAY.brighter()) {
  @Override public void paintBorder(Component c, Graphics g, int x, int y, int width, int height) {
    super.paintBorder(c, g, x, y, width, height);
    if (c.isFocusOwner()) {
      Graphics2D g2 = (Graphics2D) g.create();
      g2.setPaint(Color.DARK_GRAY);
      g2.drawRect(x, y, width - 1, height - 1);
      g2.dispose();
    }
  }
});
</code></pre>

## 参考リンク
- [JTreeのノードの文字列に余白を追加](https://ateraimemo.com/Swing/TreeCellMargin.html)
    - `JTree`の場合で、フォーカスの点線と文字列の間に余白を追加

<!-- dummy comment line for breaking list -->

## コメント
