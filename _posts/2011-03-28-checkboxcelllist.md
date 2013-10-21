---
layout: post
title: JListのセルにJCheckBoxを使用する
category: swing
folder: CheckBoxCellList
tags: [JList, JCheckBox, ListCellRenderer, MouseListener, JTree, Box]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-03-28

## JListのセルにJCheckBoxを使用する
`JList`のセルに`JCheckBox`を使用して、チェックボックスの一覧を作成します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/-EfbwsqycTvg/UlyukvM4ivI/AAAAAAAAB3o/NJBvrfM4xPA/s800/CheckBoxCellList.png)

### サンプルコード
<pre class="prettyprint"><code>class CheckBoxCellRenderer extends JCheckBox
    implements ListCellRenderer, MouseListener, MouseMotionListener {
  @Override public Component getListCellRendererComponent(
    JList list,
    Object value,
    int index,
    boolean isSelected,
    boolean cellHasFocus) {
    this.setOpaque(true);
    if(isSelected) {
      this.setBackground(list.getSelectionBackground());
      this.setForeground(list.getSelectionForeground());
    }else{
      this.setBackground(list.getBackground());
      this.setForeground(list.getForeground());
    }
    if(value instanceof CheckBoxNode) {
      this.setSelected(((CheckBoxNode)value).selected);
      this.getModel().setRollover(index==rollOverRowIndex);
    }
    this.setText(value.toString());
    return this;
  }
  private int rollOverRowIndex = -1;
  @Override public void mouseExited(MouseEvent e) {
    JList l = (JList)e.getSource();
    if(rollOverRowIndex&gt;=0) {
      l.repaint(l.getCellBounds(rollOverRowIndex, rollOverRowIndex));
      rollOverRowIndex = -1;
    }
  }
  @SuppressWarnings("unchecked")
  @Override public void mouseClicked(MouseEvent e) {
    if(e.getButton()==MouseEvent.BUTTON1) {
      JList l = (JList)e.getComponent();
      DefaultListModel m = (DefaultListModel)l.getModel();
      Point p = e.getPoint();
      int index  = l.locationToIndex(p);
      if(index&gt;=0) {
        CheckBoxNode n = (CheckBoxNode)m.get(index);
        m.set(index, new CheckBoxNode(n.text, !n.selected));
        l.repaint(l.getCellBounds(index, index));
      }
    }
  }
  @Override public void mouseMoved(MouseEvent e) {
    JList l = (JList)e.getSource();
    int index = l.locationToIndex(e.getPoint());
    if(index != rollOverRowIndex) {
      rollOverRowIndex = index;
      l.repaint();
    }
  }
  @Override public void mouseEntered(MouseEvent e) {}
  @Override public void mousePressed(MouseEvent e) {}
  @Override public void mouseReleased(MouseEvent e) {}
  @Override public void mouseDragged(MouseEvent e) {}
}
</code></pre>

### 解説
- 左: `Box`
    - `Box.createVerticalBox()`に`JCheckBox`を追加
    - `JCheckBox#setAlignmentX(Component.LEFT_ALIGNMENT);`で左揃えに設定

<!-- dummy comment line for breaking list -->

- 中: `JList`
    - `JCheckBox`を継承する`ListCellRenderer`を設定
    - チェックボックスのロールオーバーなどは、`JList`にマウスリスナーを設定して表示
    - `JList#processMouseEvent`、`JList#processMouseMotionEvent`のオーバーライドと、`JList#putClientProperty("List.isFileList", Boolean.TRUE);`で、クリックが有効になる領域をチェックボックスの幅に制限

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>JList list1 = new JList(model) {
  private CheckBoxCellRenderer renderer;
  @Override public void updateUI() {
    setForeground(null);
    setBackground(null);
    setSelectionForeground(null);
    setSelectionBackground(null);
    if(renderer!=null) {
      removeMouseListener(renderer);
      removeMouseMotionListener(renderer);
    }
    super.updateUI();
    renderer = new CheckBoxCellRenderer();
    setCellRenderer(renderer);
    addMouseListener(renderer);
    addMouseMotionListener(renderer);
  }
  //@see SwingUtilities2.pointOutsidePrefSize(...)
  private boolean pointOutsidePrefSize(Point p) {
    int index = locationToIndex(p);
    DefaultListModel m = (DefaultListModel)getModel();
    CheckBoxNode n = (CheckBoxNode)m.get(index);
    Component c = getCellRenderer().getListCellRendererComponent(
        this, n, index, false, false);
    //c.doLayout();
    Dimension d = c.getPreferredSize();
    Rectangle rect = getCellBounds(index, index);
    rect.width = d.width;
    return index &lt; 0 || !rect.contains(p);
  }
  @Override protected void processMouseEvent(MouseEvent e) {
    if(!pointOutsidePrefSize(e.getPoint())) {
      super.processMouseEvent(e);
    }
  }
  @Override protected void processMouseMotionEvent(MouseEvent e) {
    if(!pointOutsidePrefSize(e.getPoint())) {
      super.processMouseMotionEvent(e);
    }else{
      e = new MouseEvent(
          (Component)e.getSource(), MouseEvent.MOUSE_EXITED, e.getWhen(),
          e.getModifiers(), e.getX(), e.getY(),
          e.getXOnScreen(), e.getYOnScreen(),
          e.getClickCount(), e.isPopupTrigger(), MouseEvent.NOBUTTON);
      super.processMouseEvent(e);
    }
  }
};
</code></pre>

- 右: `JTree`
    - `JCheckBox`を継承する`TreeCellRenderer`を設定
        - [JTreeの葉ノードをJCheckBoxにする](http://terai.xrea.jp/Swing/CheckBoxNodeTree.html)のセルレンダラーを使用
    - `JTree#setRootVisible(false)`でルートノードを非表示に設定

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>class CheckBoxNodeRenderer extends JCheckBox implements TreeCellRenderer {
  private TreeCellRenderer renderer = new DefaultTreeCellRenderer();
  @Override public Component getTreeCellRendererComponent(
      JTree tree, Object value, boolean selected, boolean expanded,
      boolean leaf, int row, boolean hasFocus) {
    if(leaf &amp;&amp; value != null &amp;&amp; value instanceof DefaultMutableTreeNode) {
      this.setOpaque(false);
      Object userObject = ((DefaultMutableTreeNode)value).getUserObject();
      if(userObject!=null &amp;&amp; userObject instanceof CheckBoxNode) {
        CheckBoxNode node = (CheckBoxNode)userObject;
        this.setText(node.text);
        this.setSelected(node.selected);
      }
      return this;
    }
    return renderer.getTreeCellRendererComponent(
        tree, value, selected, expanded, leaf, row, hasFocus);
  }
}

class CheckBoxNodeEditor extends JCheckBox implements TreeCellEditor {
  private final JTree tree;
  public CheckBoxNodeEditor(JTree tree) {
    super();
    this.tree = tree;
    setOpaque(false);
    setFocusable(false);
    addActionListener(new ActionListener() {
      @Override public void actionPerformed(ActionEvent e) {
        stopCellEditing();
      }
    });
  }
  @Override public Component getTreeCellEditorComponent(
      JTree tree, Object value, boolean isSelected, boolean expanded,
      boolean leaf, int row) {
    if(leaf &amp;&amp; value != null &amp;&amp; value instanceof DefaultMutableTreeNode) {
      Object userObject = ((DefaultMutableTreeNode)value).getUserObject();
      if(userObject!=null &amp;&amp; userObject instanceof CheckBoxNode) {
        this.setSelected(((CheckBoxNode)userObject).selected);
      } else {
        this.setSelected(false);
      }
      this.setText(value.toString());
    }
    return this;
  }
  @Override public Object getCellEditorValue() {
    return new CheckBoxNode(getText(), isSelected());
  }
  @Override public boolean isCellEditable(EventObject e) {
    return (e != null &amp;&amp; e instanceof MouseEvent);
  }
  //Copid from AbstractCellEditor
  //protected EventListenerList listenerList = new EventListenerList();
  //transient protected ChangeEvent changeEvent = null;
  @Override public boolean shouldSelectCell(java.util.EventObject anEvent) {
//...
</code></pre>

### 参考リンク
- [JTreeの葉ノードをJCheckBoxにする](http://terai.xrea.jp/Swing/CheckBoxNodeTree.html)

<!-- dummy comment line for breaking list -->

### コメント
- 補足として追記していた`JTree`を使用するサンプルを本体に取り込んで、スクリーンショットなどを更新。 -- [aterai](http://terai.xrea.jp/aterai.html) 2013-10-15 (火) 11:56:41
- Could you give me some smaller notes? <a href=" [http://www.treatmentforliving.com/treatmenttopic/treating-panic](http://www.treatmentforliving.com/treatmenttopic/treating-panic) ">buy betamethasone dipropionate</a>  â¢ Find ways to live in the new culture <a href=" [http://www.palestinejn.org/en/about-pjn](http://www.palestinejn.org/en/about-pjn) ">buspar 10 mg mexico</a>  Advanced Clinical Community II Syllabus <a href=" [http://feirametalmecanica.com.br/sobre-a-feira/](http://feirametalmecanica.com.br/sobre-a-feira/) ">buy singulair online</a>  Program Administration Fee $150  -- [Ayden](http://terai.xrea.jp/Ayden.html) 2013-10-21 (月) 10:23:25
- We'll need to take up references <a href=" [http://www.atreuspharmadev.com/post/online-pharmacy](http://www.atreuspharmadev.com/post/online-pharmacy) ">celexa xanax together</a>  primary/ambulatory care. Some skills may be completed during elective rotations as well. <a href=" [http://www.healtheconomicsconf.net/contact-us](http://www.healtheconomicsconf.net/contact-us) ">celebrex 20 mg</a>  should be taken will be reported <a href=" [http://unghiul.info/invatamint](http://unghiul.info/invatamint) ">strattera 25mg coupon for cash patient</a>  recommend you send your Visa application to the Kenya Embassy at least six <a href=" [http://www.palestinejn.org/en/about-pjn](http://www.palestinejn.org/en/about-pjn) ">buspirone buspar half life</a>  Total picture elements1077(H) × 788(V), 850,000 pixels4  -- [Jason](http://terai.xrea.jp/Jason.html) 2013-10-21 (月) 10:23:27
- I support Manchester United <a href=" [http://www.pettrust.org.uk/resources/blog](http://www.pettrust.org.uk/resources/blog) ">avanafil 50 mg</a>  completed as close control unless otherwise directed by PHARMAC or dispensed in <a href=" [http://www.atreuspharmadev.com/post/online-pharmacy](http://www.atreuspharmadev.com/post/online-pharmacy) ">buy celexa 40 mg</a>  Julius is an invaluable assistant in the kitchen and helps Peninah keep ahead of the dishes and the chopping of <a href=" [http://unghiul.info/invatamint](http://unghiul.info/invatamint) ">strattera cheaper</a>  legal and ethical principles. <a href=" [http://feirametalmecanica.com.br/sobre-a-feira/](http://feirametalmecanica.com.br/sobre-a-feira/) ">singulair tablets</a>  5.4. Obtain, appraise and apply  patient-specific factors  -- [Landon](http://terai.xrea.jp/Landon.html) 2013-10-21 (月) 10:23:28

<!-- dummy comment line for breaking list -->

