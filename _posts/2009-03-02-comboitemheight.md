---
layout: post
category: swing
folder: ComboItemHeight
title: JComboBoxの高さを変更する
tags: [JComboBox, ListCellRenderer]
author: aterai
pubdate: 2009-03-02T12:37:58+09:00
description: JComboBox自体の高さや、ドロップダウンリスト内にあるアイテムの高さを変更します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTJ6VVptrI/AAAAAAAAAVI/x72zWGymqHk/s800/ComboItemHeight.png
comments: true
---
## 概要
`JComboBox`自体の高さや、ドロップダウンリスト内にあるアイテムの高さを変更します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTJ6VVptrI/AAAAAAAAAVI/x72zWGymqHk/s800/ComboItemHeight.png %}

## サンプルコード
<pre class="prettyprint"><code>JComboBox&lt;String&gt; combo2 = new JComboBox&lt;&gt;(items);
combo2.setRenderer(new DefaultListCellRenderer() {
  private int cheight;
  @Override public Component getListCellRendererComponent(
      JList list, Object value, int index,
      boolean isSelected, boolean cellHasFocus) {
    super.getListCellRendererComponent(list, value, index, isSelected, cellHasFocus);
    Dimension d = super.getPreferredSize();
    cheight = index &lt; 0 ? d.height : 32;
    return this;
  }
  @Override public Dimension getPreferredSize() {
    Dimension d = super.getPreferredSize();
    d.height = cheight;
    return d;
  }
});
</code></pre>

## 解説
- `setPreferredSize`
    - セルレンダラーに`setPreferredSize(...)`メソッドで高さを設定
        
        <pre class="prettyprint"><code>JComboBox combo1 = new JComboBox(items);
        JLabel renderer1 = (JLabel) combo1.getRenderer();
        renderer1.setPreferredSize(new Dimension(0, 32));
</code></pre>
- `getListCellRendererComponent`
    - セルレンダラーの`getListCellRendererComponent(...)`メソッド内で、`index`が`0`以上の場合は`getPreferredSize()`メソッドで取得する高さを切り替える

<!-- dummy comment line for breaking list -->

- `html`
    - `html`タグを使用してセルレンダラーに高さを指定
        
        <pre class="prettyprint"><code>JComboBox&lt;String&gt; combo3 = new JComboBox&lt;&gt;(items);
        combo3.setRenderer(new DefaultListCellRenderer() {
          @Override public Component getListCellRendererComponent(
              JList list, Object value, int index,
              boolean isSelected, boolean cellHasFocus) {
            String title = Objects.toString(value, "");
            if (index &gt;= 0) {
              title = String.format("&lt;html&gt;&lt;table&gt;&lt;td height='32'&gt;%s", value);
            }
            return super.getListCellRendererComponent(list, title, index, isSelected, cellHasFocus);
          }
        });
</code></pre>
- `icon`
    - 幅ゼロのアイコンを使用してセルレンダラーに高さを指定
        
        <pre class="prettyprint"><code>JComboBox&lt;String&gt; combo4 = new JComboBox&lt;&gt;(items);
        combo4.setRenderer(new DefaultListCellRenderer() {
          @Override public Component getListCellRendererComponent(
              JList list, Object value, int index,
              boolean isSelected, boolean cellHasFocus) {
            super.getListCellRendererComponent(list, value, index, isSelected, cellHasFocus);
            if (index &gt;= 0) {
              setIcon(new Icon() {
                @Override public void paintIcon(Component c, Graphics g, int x, int y) {}
                @Override public int getIconWidth()  { return 0;  }
                @Override public int getIconHeight() { return 32; }
              });
            } else {
              setIcon(null);
            }
            //setIconTextGap(0);
            return this;
          }
        });
</code></pre>

<!-- dummy comment line for breaking list -->
- - - -
- `DefaultListCellRenderer`を編集可能にした`JComboBox`に設定すると、リストアイテム文字列が空`""`の場合、ドロップダウンリスト内でのそのアイテムの高さが余白分のみ(`2px`)になってしまう
    - 参考: [java - DefaultListCellRenderer does not render empty String correctly when using an editable combo box - Stack Overflow](https://stackoverflow.com/questions/30755058/defaultlistcellrenderer-does-not-render-empty-string-correctly-when-using-an-edi)
    - 上記のサンプルも`DefaultListCellRenderer`を使用しているが、直接高さを指定しているので編集可にしてもこの状態にはならない
    - `JComboBox#setPrototypeDisplayValue(...)`で文字列を設定していても、高さには効果がない
    - 回答にある`BasicComboBoxRenderer`でこの状態にならない理由は、以下のように`BasicComboBoxRenderer#getPreferredSize()`をオーバーライドし、空白文字を一時的に追加してから高さを求めているため
        
        <pre class="prettyprint"><code>@Override public Dimension getPreferredSize() {
          Dimension size;
          if ((this.getText() == null) || (this.getText().equals(""))) {
            setText(" ");
            size = super.getPreferredSize();
            setText("");
          } else {
            size = super.getPreferredSize();
          }
          return size;
        }
</code></pre>
    - * 参考リンク [#reference]
- [java - DefaultListCellRenderer does not render empty String correctly when using an editable combo box - Stack Overflow](https://stackoverflow.com/questions/30755058/defaultlistcellrenderer-does-not-render-empty-string-correctly-when-using-an-edi)

<!-- dummy comment line for breaking list -->

## コメント
- `html`タグを使用するサンプルなどを追加。 -- *aterai* 2013-12-20 (金) 20:06:03
- 幅ゼロのアイコンを使用するサンプルなどを追加。 -- *aterai* 2015-06-11 (金) 11:23:55

<!-- dummy comment line for breaking list -->
