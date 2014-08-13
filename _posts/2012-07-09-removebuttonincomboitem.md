---
layout: post
title: JComboBoxのドロップダウンリストにJButtonを追加
category: swing
folder: RemoveButtonInComboItem
tags: [JComboBox, JButton, JList, BasicComboPopup, ListCellRenderer, MouseListener]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-07-09

## JComboBoxのドロップダウンリストにJButtonを追加
`JButton`のドロップダウンリストで、各アイテムにクリック可能な`JButton`を追加しこれを削除します。


{% download https://lh6.googleusercontent.com/-x9uTOO9fSds/T_pElwy8GBI/AAAAAAAABPM/Jx30phjG3bM/s800/RemoveButtonInComboItem.png %}

### サンプルコード
<pre class="prettyprint"><code>class CellButtonsMouseListener extends MouseAdapter{
  private int prevIndex = -1;
  private JButton prevButton = null;
  @Override public void mouseMoved(MouseEvent e) {
    JList list = (JList)e.getComponent();
    Point pt = e.getPoint();
    int index  = list.locationToIndex(pt);
    if(!list.getCellBounds(index, index).contains(pt)) {
      if(prevIndex&gt;=0) {
        Rectangle r = list.getCellBounds(prevIndex, prevIndex);
        if(r!=null) {
          list.repaint(r);
        }
      }
      index = -1;
      prevButton = null;
      return;
    }
    if(index&gt;=0) {
      JButton button = getButton(list, pt, index);
      ButtonsRenderer renderer = (ButtonsRenderer)list.getCellRenderer();
      renderer.button = button;
      if(button != null) {
        button.getModel().setRollover(true);
        renderer.rolloverIndex = index;
        if(!button.equals(prevButton)) {
          Rectangle r = list.getCellBounds(prevIndex, index);
          if(r!=null) {
            list.repaint(r);
          }
        }
      }else{
        renderer.rolloverIndex = -1;
        Rectangle r = null;
        if(prevIndex != index) {
          r = list.getCellBounds(index, index);
        }else if(prevIndex&gt;=0 &amp;&amp; prevButton!=null) {
          r = list.getCellBounds(prevIndex, prevIndex);
        }
        if(r!=null) {
          list.repaint(r);
        }
        prevIndex = -1;
      }
      prevButton = button;
    }
    prevIndex = index;
  }
  @Override public void mousePressed(MouseEvent e) {
    JList list = (JList)e.getComponent();
    Point pt = e.getPoint();
    int index  = list.locationToIndex(pt);
    if(index&gt;=0) {
      JButton button = getButton(list, pt, index);
      if(button != null) {
        ButtonsRenderer renderer = (ButtonsRenderer)list.getCellRenderer();
        renderer.button = button;
        list.repaint(list.getCellBounds(index, index));
      }
    }
  }
  @Override public void mouseReleased(MouseEvent e) {
    JList list = (JList)e.getComponent();
    Point pt = e.getPoint();
    int index  = list.locationToIndex(pt);
    if(index&gt;=0) {
      JButton button = getButton(list, pt, index);
      if(button != null) {
        ButtonsRenderer renderer = (ButtonsRenderer)list.getCellRenderer();
        renderer.button = null;
        button.doClick();
        Rectangle r = list.getCellBounds(index, index);
        if(r!=null) {
          list.repaint(r);
        }
      }
    }
  }
  @SuppressWarnings("unchecked")
  private static JButton getButton(JList list, Point pt, int index) {
    Container c = (Container)list.getCellRenderer().getListCellRendererComponent(
        list, "", index, false, false);
    Rectangle r = list.getCellBounds(index, index);
    c.setBounds(r);
    pt.translate(0,-r.y);
    Component b = SwingUtilities.getDeepestComponentAt(c, pt.x, pt.y);
    if(b instanceof JButton) {
      return (JButton)b;
    }else{
      return null;
    }
  }
}
</code></pre>

### 解説
`JComboBox`のドロップダウンリスト(`BasicComboPopup`)から`JList`を取得し、これに上記のような`MouseListener`を追加しています。この`JList`がクリックされた場合、レンダラーから対応するセルに表示されている`JButton`を取得し、`button.doClick()`を呼び出します。

<pre class="prettyprint"><code>Accessible a = getAccessibleContext().getAccessibleChild(0);
if(a instanceof BasicComboPopup) {
  BasicComboPopup pop = (BasicComboPopup)a;
  JList list = pop.getList();
  CellButtonsMouseListener cbml = new CellButtonsMouseListener();
  list.addMouseListener(cbml);
  list.addMouseMotionListener(cbml);
}
</code></pre>

- - - -
- メモ: 削除ボタンがクリックされてもドロップダウンリストは表示されたままになるように、`MutableComboBoxModel#removeElementAt(index);`のあとで`comboBox.showPopup();`
    - `BasicComboPopup`が、フレーム外に表示されている場合(`Heavy weight`)、一旦閉じたあとで再度開かれるように見える

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JListのセル内にJButtonを配置する](http://terai.xrea.jp/Swing/ButtonsInListCell.html)

<!-- dummy comment line for breaking list -->

### コメント
