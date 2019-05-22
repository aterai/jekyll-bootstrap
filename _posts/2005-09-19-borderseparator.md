---
layout: post
category: swing
folder: BorderSeparator
title: JComboBoxのアイテムをBorderで修飾してグループ分け
tags: [JComboBox, Border, ListCellRenderer, MatteBorder]
author: aterai
pubdate: 2005-09-19T09:10:06+09:00
description: JComboBoxのアイテムをBorderを使用して修飾してグループ分けします。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTIMVjWegI/AAAAAAAAASY/yM_W_tfnios/s800/BorderSeparator.png
comments: true
---
## 概要
`JComboBox`のアイテムを`Border`を使用して修飾してグループ分けします。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTIMVjWegI/AAAAAAAAASY/yM_W_tfnios/s800/BorderSeparator.png %}

## サンプルコード
<pre class="prettyprint"><code>JComboBox combobox = new JComboBox();
JSeparator sep = new JSeparator();
ListCellRenderer lcr = combobox.getRenderer();
combobox.setRenderer(new ListCellRenderer() {
  @Override public Component getListCellRendererComponent(
               JList list, Object value, int index,
               boolean isSelected, boolean cellHasFocus) {
    MyItem item = (MyItem) value;
    JLabel label = (JLabel) lcr.getListCellRendererComponent(
                    list, item, index, isSelected, cellHasFocus);
    if (item.hasSeparator()) {
      label.setBorder(
             BorderFactory.createMatteBorder(1, 0, 0, 0, Color.GRAY));
    } else {
      label.setBorder(BorderFactory.createEmptyBorder());
    }
    return label;
  }
});
DefaultComboBoxModel model = new DefaultComboBoxModel();
model.addElement(new MyItem("aaaa"));
model.addElement(new MyItem("eeeeeeeee", true));
model.addElement(new MyItem("bbb12"));
combobox.setModel(model);
combobox.setEditable(true);
</code></pre>

<pre class="prettyprint"><code>class MyItem {
  private final String  item;
  private final boolean flag;
  public MyItem(String str) {
    this(str, false);
  }
  public MyItem(String str, boolean flg) {
    item = str;
    flag = flg;
  }
  @Override public String toString() {
    return item;
  }
  public boolean hasSeparator() {
    return flag;
  }
}
// ...
</code></pre>

## 解説
レンダラーの中で、`JLabel`を`MatteBorder`で修飾し、`JSeparator`を使用せずに`Item`をグループ分けしているように見せかけています。

- `JComboBox`が編集可
    - フィールド表示には`ListCellRenderer`ではなく`JTextField`が使用されるため、[JComboBoxにJSeparatorを挿入](https://ateraimemo.com/Swing/ComboBoxSeparator.html)する方法より簡単に区切りを表現可能
- `JComboBox`が編集不可
    - [JComboBox Items with Separators - Santhosh Kumar's Weblog](http://www.jroller.com/santhosh/entry/jcombobox_items_with_separators)のようにフィールド表示(`index!=-1`の場合)で区切りが表示されないようにする必要がある
        
        <pre class="prettyprint"><code>combobox.setRenderer(new ListCellRenderer() {
          @Override public Component getListCellRendererComponent(
                       JList list, Object value, int index,
                       boolean isSelected, boolean cellHasFocus) {
            MyItem item = (MyItem) value;
            JLabel label = (JLabel) lcr.getListCellRendererComponent(
                            list, item, index, isSelected, cellHasFocus);
            if (index != -1 &amp;&amp; item.hasSeparator()) {
              label.setBorder(
                     BorderFactory.createMatteBorder(1, 0, 0, 0, Color.GRAY));
            } else {
              label.setBorder(BorderFactory.createEmptyBorder());
            }
            return label;
          }
        });
</code></pre>
    - * 参考リンク [#reference]
- [JComboBoxにJSeparatorを挿入](https://ateraimemo.com/Swing/ComboBoxSeparator.html)
- [JComboBox Items with Separators - Santhosh Kumar's Weblog](http://www.jroller.com/santhosh/entry/jcombobox_items_with_separators)

<!-- dummy comment line for breaking list -->

## コメント
- `index!=-1`を追加、スクリーンショットを更新 -- *aterai* 2008-09-04 (木) 17:53:47

<!-- dummy comment line for breaking list -->
