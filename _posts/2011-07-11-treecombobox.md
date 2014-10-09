---
layout: post
category: swing
folder: TreeComboBox
title: JComboBoxのItemをTree状に表示する
tags: [JComboBox, TreeModel]
author: aterai
pubdate: 2011-07-11T15:16:42+09:00
description: JComboBoxのドロップダウンリストに表示するItemをTree状に配置します。
comments: true
---
## 概要
`JComboBox`のドロップダウンリストに表示する`Item`を`Tree`状に配置します。

{% download https://lh6.googleusercontent.com/-5GlQEjeLoH8/ThqUIL9b4UI/AAAAAAAAA_E/9h5dxYzSSm8/s800/TreeComboBox.png %}

## サンプルコード
<pre class="prettyprint"><code>class TreeComboBox extends JComboBox {
  public TreeComboBox() {
    super();
    setRenderer(new DefaultListCellRenderer() {
      @Override public Component getListCellRendererComponent(
          JList list, Object value, int index,
          boolean isSelected, boolean cellHasFocus) {
        JComponent c;
        if(value instanceof DefaultMutableTreeNode) {
          DefaultMutableTreeNode node = (DefaultMutableTreeNode)value;
          int indent = 2 + (index&lt;0?0:(node.getPath().length-2)*16);
          if(node.isLeaf()) {
            c = (JComponent)super.getListCellRendererComponent(
                list,value,index,isSelected,cellHasFocus);
          }else{
            c = (JComponent)super.getListCellRendererComponent(
                list,value,index,false,false);
            JLabel l = (JLabel)c;
            l.setForeground(Color.WHITE);
            l.setBackground(Color.GRAY.darker());
          }
          c.setBorder(BorderFactory.createEmptyBorder(0,indent,0,0));
        }else{
          c = (JComponent)super.getListCellRendererComponent(
              list,value,index,isSelected,cellHasFocus);
        }
        return c;
      }
    });
    Action up = new AbstractAction() {
      @Override public void actionPerformed(ActionEvent e) {
        int si = getSelectedIndex();
        for(int i = si-1;i&gt;=0;i--) {
          Object o = getItemAt(i);
          if(o instanceof TreeNode &amp;&amp; ((TreeNode)o).isLeaf()) {
            setSelectedIndex(i);
            break;
          }
        }
      }
    };
    Action down = new AbstractAction() {
      @Override public void actionPerformed(ActionEvent e) {
        int si = getSelectedIndex();
        for(int i = si+1;i&lt;getModel().getSize();i++) {
          Object o = getItemAt(i);
          if(o instanceof TreeNode &amp;&amp; ((TreeNode)o).isLeaf()) {
            setSelectedIndex(i);
            break;
          }
        }
      }
    };
    ActionMap am = getActionMap();
    am.put("selectPrevious3", up);
    am.put("selectNext3", down);
    InputMap im = getInputMap();
    im.put(KeyStroke.getKeyStroke(KeyEvent.VK_UP, 0),      "selectPrevious3");
    im.put(KeyStroke.getKeyStroke(KeyEvent.VK_KP_UP, 0),   "selectPrevious3");
    im.put(KeyStroke.getKeyStroke(KeyEvent.VK_DOWN, 0),    "selectNext3");
    im.put(KeyStroke.getKeyStroke(KeyEvent.VK_KP_DOWN, 0), "selectNext3");
  }
  private boolean isNotSelectableIndex = false;
  @Override public void setPopupVisible(boolean v) {
    if(!v &amp;&amp; isNotSelectableIndex) {
      isNotSelectableIndex = false;
    }else{
      super.setPopupVisible(v);
    }
  }
  @Override public void setSelectedIndex(int index) {
    Object o = getItemAt(index);
    if(o instanceof TreeNode &amp;&amp; !((TreeNode)o).isLeaf()) {
      isNotSelectableIndex = true;
    }else{
      super.setSelectedIndex(index);
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、`TreeModel`から取得した`TreeNode`を`JComboBox`の`Item`として、ドロップダウンリストに表示しています。

- `TreeNode#isLeaf()`の場合だけ、選択可能
    - [JComboBoxのアイテムを選択不可にする](http://terai.xrea.jp/Swing/DisableItemComboBox.html)
- 子要素のインデントは`BorderFactory.createEmptyBorder(0,indent,0,0)`

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Tree inside JComboBox - Santhosh Kumar's Weblog](http://www.jroller.com/santhosh/entry/tree_inside_jcombobox)
    - こちらで解説されているサンプルでは、`TreeCellRenderer`を使っているのでノードアイコンなども`JTree`のものを表示できるようになっています。
- [JComboBoxのアイテムを選択不可にする](http://terai.xrea.jp/Swing/DisableItemComboBox.html)

<!-- dummy comment line for breaking list -->

## コメント
- `src.zip`などが正しいディレクトリに配置されてなかったのを修正。 -- *aterai* 2011-07-13 (水) 19:02:23

<!-- dummy comment line for breaking list -->
