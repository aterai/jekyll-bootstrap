---
layout: post
title: JComboBoxのアイテムをBorderで修飾してグループ分け
category: swing
folder: BorderSeparator
tags: [JComboBox, Border, ListCellRenderer, MatteBorder]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-09-19

## JComboBoxのアイテムをBorderで修飾してグループ分け
`JComboBox`のアイテムを`Border`を使用して修飾してグループ分けします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTIMVjWegI/AAAAAAAAASY/yM_W_tfnios/s800/BorderSeparator.png)

### サンプルコード
<pre class="prettyprint"><code>final JComboBox combobox = new JComboBox();
final JSeparator sep = new JSeparator();
final ListCellRenderer lcr = combobox.getRenderer();
combobox.setRenderer(new ListCellRenderer() {
  public Component getListCellRendererComponent(
               JList list, Object value, int index,
               boolean isSelected, boolean cellHasFocus) {
    MyItem item = (MyItem)value;
    JLabel label = (JLabel)lcr.getListCellRendererComponent(
                    list,item,index,isSelected,cellHasFocus);
    if(item.hasSeparator()) {
      label.setBorder(
             BorderFactory.createMatteBorder(1,0,0,0,Color.GRAY));
    }else{
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

<pre class="prettyprint"><code>class MyItem{
  private final String  item;
  private final boolean flag;
  public MyItem(String str) {
    this(str,false);
  }
  public MyItem(String str, boolean flg) {
    item = str;
    flag = flg;
  }
  public String toString() {
    return item;
  }
  public boolean hasSeparator() {
    return flag;
  }
}
//......
</code></pre>

### 解説
レンダラーの中で、`JLabel`を`MatteBorder`で修飾し、`JSeparator`を使用せずに`Item`をグループ分けしているように見せかけています。

コンボボックスが編集可の場合は、フィールド表示にはレンダラーではなく、`JTextField`が使用されるため、[JComboBoxにJSeparatorを挿入](http://terai.xrea.jp/Swing/ComboBoxSeparator.html)する方法より簡単に区切りを表現することができます。

- - - -
コンボボックスが編集不可の場合は、[JComboBox Items with Separators - Santhosh Kumar's Weblog](http://www.jroller.com/santhosh/entry/jcombobox_items_with_separators)のようにフィールド表示(`index!=-1`の場合)で区切りが表示されないようにする必要があります。

<pre class="prettyprint"><code>combobox.setRenderer(new ListCellRenderer() {
  public Component getListCellRendererComponent(
               JList list, Object value, int index,
               boolean isSelected, boolean cellHasFocus) {
    MyItem item = (MyItem)value;
    JLabel label = (JLabel)lcr.getListCellRendererComponent(
                    list,item,index,isSelected,cellHasFocus);
    if(index!=-1 &amp;&amp; item.hasSeparator()) {
      label.setBorder(
             BorderFactory.createMatteBorder(1,0,0,0,Color.GRAY));
    }else{
      label.setBorder(BorderFactory.createEmptyBorder());
    }
    return label;
  }
});
</code></pre>

### 参考リンク
- [JComboBoxにJSeparatorを挿入](http://terai.xrea.jp/Swing/ComboBoxSeparator.html)
- [JComboBox Items with Separators - Santhosh Kumar's Weblog](http://www.jroller.com/santhosh/entry/jcombobox_items_with_separators)

<!-- dummy comment line for breaking list -->

### コメント
- `index!=-1`を追加、スクリーンショットを更新 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-09-04 (木) 17:53:47

<!-- dummy comment line for breaking list -->

