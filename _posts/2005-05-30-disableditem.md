---
layout: post
title: JListの任意のItemを選択不可にする
category: swing
folder: DisabledItem
tags: [JList, ListCellRenderer, ActionMap]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-05-30

## JListの任意のItemを選択不可にする
`JList`の任意の`Item`を選択不可にするようなレンダラーを設定します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTLAYVmo3I/AAAAAAAAAW4/3MUtTm4ixyo/s800/DisabledItem.png)

### サンプルコード
<pre class="prettyprint"><code>final JList = new JList();
final ListCellRenderer r = list.getCellRenderer();
final Vector disableIndexSet = new Vector();
initDisableIndex(disableIndexSet);
list.setCellRenderer(new ListCellRenderer() {
  @Override public Component getListCellRendererComponent(JList list, Object value,
                   int index, boolean isSelected, boolean cellHasFocus) {
    Component c;
    if(disableIndexSet.contains(Integer.valueOf(index))) {
      c = r.getListCellRendererComponent(list,value,index,false,false);
      c.setEnabled(false);
    }else{
      c = r.getListCellRendererComponent(list,value,index,isSelected,cellHasFocus);
    }
    return c;
  }
});
ActionMap am = list.getActionMap();
am.put("selectNextRow", new AbstractAction() {
  @Override public void actionPerformed(ActionEvent ae) {
    int index = list.getSelectedIndex()+1;
    for(int i=index;i&lt;list.getModel().getSize();i++) {
      if(!disableIndexSet.contains(Integer.valueOf(i))) {
        list.setSelectedIndex(i);
        break;
      }
    }
  }
});
</code></pre>

### 解説
上記のサンプルでは、カンマ区切りで入力したインデックスのアイテムを選択不可にすることができます。

選択可か不可かはセルレンダラー中で判断しています。このセルレンダラーでは、インデックスが選択不可の場合、オリジナルのセルレンダラーから選択無し、フォーカス無しのコンポーネントを取得し、さらに`setEnabled(false)`として返しています。

また、<kbd>Up</kbd><kbd>Down</kbd>キーでアイテムの選択を移動する場合、選択不可にしたアイテムを飛ばすように、`selectNextRow`などのアクションを変更しています。

### 参考リンク
- [JComboBoxのアイテムを選択不可にする](http://terai.xrea.jp/Swing/DisableItemComboBox.html)

<!-- dummy comment line for breaking list -->

### コメント
