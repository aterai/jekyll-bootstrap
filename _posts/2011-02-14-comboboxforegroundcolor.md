---
layout: post
title: JComboBoxの文字色を変更する
category: swing
folder: ComboBoxForegroundColor
tags: [JComboBox, ListCellRenderer, Html]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-02-14

## JComboBoxの文字色を変更する
`JComboBox`の文字色を変更します。

{% download %}

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TVjIM1AMFkI/AAAAAAAAA1M/BSd3As9dxZE/s800/ComboBoxForegroundColor.png)

### サンプルコード
<pre class="prettyprint"><code>class ComboForegroundRenderer extends DefaultListCellRenderer {
  private final Color selectionBackground = new Color(240,245,250);
  private final JComboBox combo;
  public ComboForegroundRenderer(JComboBox combo) {
    this.combo = combo;
  }
  @Override public Component getListCellRendererComponent(JList list,
      Object value, int index, boolean isSelected, boolean hasFocus) {
    if(value!=null &amp;&amp; value instanceof ColorItem) {
      ColorItem item = (ColorItem) value;
      Color ic = item.color;
      if(index&lt;0 &amp;&amp; ic!=null &amp;&amp; !ic.equals(combo.getForeground())) {
        combo.setForeground(ic); //Windows, Motif Look&amp;Feel
        list.setSelectionForeground(ic);
        list.setSelectionBackground(selectionBackground);
      }
      JLabel l = (JLabel)super.getListCellRendererComponent(
          list, item.description, index, isSelected, hasFocus);
      l.setForeground(ic);
      l.setBackground(isSelected?selectionBackground:list.getBackground());
      return l;
    }else{
      super.getListCellRendererComponent(
          list, value, index, isSelected, hasFocus);
      return this;
    }
  }
}
</code></pre>

### 解説
上記のサンプルでは、編集不可になっている`JComboBox`の文字色を、選択中のアイテムから取得した色に変更するようなセルレンダラを設定しています。

- `Default`
    - セルレンダラはデフォルト
- `setForeground`
    - `ListCellRenderer`で`JList`の選択時文字色(`JList#setSelectionForeground`)、選択時背景色(`JList#setSelectionBackground`)を変更
    - `XPStyle.getXP()!=null`な`Windows LookAndFeel`や、`Motif LookAndFeel`の場合、フィールド部分の非選択時文字色は、`JComboBox`の文字色(`getForeground()`)が使用されるため、セルレンダラで、`JComboBox#setForeground(Color)`を使用
- `Html tag`
    - 選択時背景色は、上記の`setForeground`と同様に、`JList#setSelectionBackground`を使用
    - セルレンダラで文字色を`Html`タグで変更

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>class ComboHtmlRenderer extends DefaultListCellRenderer {
  private final Color selectionBackground = new Color(240,245,250);
  @Override public Component getListCellRendererComponent(JList list,
      Object value, int index, boolean isSelected, boolean hasFocus) {
    ColorItem item = (ColorItem) value;
    if(index&lt;0) {
      list.setSelectionBackground(selectionBackground);
    }
    JLabel l = (JLabel)super.getListCellRendererComponent(
      list, value, index, isSelected, hasFocus);
    l.setText("&lt;html&gt;&lt;font color="+hex(item.color)+"&gt;"+item.description);
    l.setBackground(isSelected?selectionBackground:list.getBackground());
    return l;
  }
  private static String hex(Color c) {
    return String.format("#%06x", c.getRGB()&amp;0xffffff);
  }
}
</code></pre>

### 参考リンク
- [JComboBoxの色を変更](http://terai.xrea.jp/Swing/ColorComboBox.html)

<!-- dummy comment line for breaking list -->

### コメント
