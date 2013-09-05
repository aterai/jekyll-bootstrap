---
layout: post
title: JComboBoxのアイテムを選択不可にする
category: swing
folder: DisableItemComboBox
tags: [JComboBox, ListCellRenderer, ActionMap, InputMap]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-04-14

## JComboBoxのアイテムを選択不可にする
`JComboBox`のドロップダウンリストで、指定したアイテムを選択不可にします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh3.ggpht.com/_9Z4BYR88imo/TQTLHzjDYpI/AAAAAAAAAXE/M4bkzWJetUI/s800/DisableItemComboBox.png)

### サンプルコード
<pre class="prettyprint"><code>class MyComboBox extends JComboBox {
  public MyComboBox() {
    super();
    final ListCellRenderer r = getRenderer();
    setRenderer(new ListCellRenderer() {
      @Override public Component getListCellRendererComponent(JList list,
          Object value, int index, boolean isSelected, boolean cellHasFocus) {
        Component c;
        if(disableIndexSet.contains(index)) {
          c = r.getListCellRendererComponent(list,value,index,false,false);
          c.setEnabled(false);
        }else{
          c = r.getListCellRendererComponent(list,value,index,isSelected,cellHasFocus);
          c.setEnabled(true);
        }
        return c;
      }
    });
    Action up = new AbstractAction() {
      @Override public void actionPerformed(ActionEvent e) {
        int si = getSelectedIndex();
        for(int i = si-1;i&gt;=0;i--) {
          if(!disableIndexSet.contains(i)) {
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
          if(!disableIndexSet.contains(i)) {
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
  private final HashSet&lt;Integer&gt; disableIndexSet = new HashSet&lt;Integer&gt;();
  private boolean isDisableIndex = false;
  public void setDisableIndex(HashSet&lt;Integer&gt; set) {
    disableIndexSet.clear();
    for(Integer i:set) {
      disableIndexSet.add(i);
    }
  }
  @Override public void setPopupVisible(boolean v) {
    if(!v &amp;&amp; isDisableIndex) {
      isDisableIndex = false;
    }else{
      super.setPopupVisible(v);
    }
  }
  @Override public void setSelectedIndex(int index) {
    if(disableIndexSet.contains(index)) {
      isDisableIndex = true;
    }else{
      //isDisableIndex = false;
      super.setSelectedIndex(index);
    }
  }
}
</code></pre>

### 解説
上記のサンプルでは、以下の方法でドロップダウンリストの特定のアイテムを選択できないように設定しています。

- 表示
    - セルレンダラーで`setEnabled`などを設定
- 選択不可
    - `setSelectedIndex`をオーバーライド
- 選択不可アイテムをクリックしてもポップアップを閉じない
    - `setPopupVisible`をオーバーライド
- キー操作で選択不可アイテムを無視
    - `ActionMap`、`InputMap`の設定

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JListの任意のItemを選択不可にする](http://terai.xrea.jp/Swing/DisabledItem.html)

<!-- dummy comment line for breaking list -->

### コメント