---
layout: post
title: JListのセルにJCheckBoxを使用する
category: swing
folder: CheckBoxCellList
tags: [JList, JCheckBox, ListCellRenderer, MouseListener, JTree]
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

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TZAiQ_MSc_I/AAAAAAAAA4k/FiVk_o38jyY/s800/CheckBoxCellList.png)

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
- 左: `JCheckBox Cell in JList`
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

- 右: `JCheckBox in Box`
    - `Box.createVerticalBox()`に`JCheckBox`を追加
    - `JCheckBox#setAlignmentX(Component.LEFT_ALIGNMENT);`で左揃えに設定

<!-- dummy comment line for breaking list -->

- - - -
[JTreeの葉ノードをJCheckBoxにする](http://terai.xrea.jp/Swing/CheckBoxNodeTree.html)のセルレンダラーを使った`JTree`に、`JTree#setRootVisible(false)`を設定しても、ほぼ同様のチェックボックスの一覧を作成することができます。

<pre class="prettyprint"><code>import java.awt.*;
import java.awt.event.*;
import java.util.*;
import javax.swing.*;
import javax.swing.event.*;
import javax.swing.tree.*;

public class TreeCheckBoxListTest {
  public JComponent makeUI() {
    DefaultMutableTreeNode root = new DefaultMutableTreeNode("JTree");
    for(int i=0; i&lt;16; i++) {
      root.add(new DefaultMutableTreeNode(new CheckBoxNode("No."+i, i%2==0)));
    }
    JTree tree = new JTree(new DefaultTreeModel(root));
    tree.setEditable(true);
    tree.setRootVisible(false);
    tree.setCellRenderer(new CheckBoxNodeRenderer());
    tree.setCellEditor(new CheckBoxNodeEditor(tree));
    return new JScrollPane(tree);
  }
  public static void main(String[] args) {
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        createAndShowGUI();
      }
    });
  }
  public static void createAndShowGUI() {
    JFrame f = new JFrame();
    f.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
    f.getContentPane().add(new TreeCheckBoxListTest().makeUI());
    f.setSize(320, 240);
    f.setLocationRelativeTo(null);
    f.setVisible(true);
  }
}
class CheckBoxNode {
  public final String text;
  public final boolean selected;
  public CheckBoxNode(String text, boolean selected) {
    this.text = text;
    this.selected = selected;
  }
  @Override public String toString() {
    return text;
  }
}

class CheckBoxNodeRenderer extends JCheckBox implements TreeCellRenderer {
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
    return true;
  }
  @Override public boolean stopCellEditing() {
    fireEditingStopped();
    return true;
  }
  @Override public void  cancelCellEditing() {
    fireEditingCanceled();
  }
  @Override public void addCellEditorListener(CellEditorListener l) {
    listenerList.add(CellEditorListener.class, l);
  }
  @Override public void removeCellEditorListener(CellEditorListener l) {
    listenerList.remove(CellEditorListener.class, l);
  }
  public CellEditorListener[] getCellEditorListeners() {
    return listenerList.getListeners(CellEditorListener.class);
  }
  protected void fireEditingStopped() {
    // Guaranteed to return a non-null array
    Object[] listeners = listenerList.getListenerList();
    // Process the listeners last to first, notifying
    // those that are interested in this event
    for(int i = listeners.length-2; i&gt;=0; i-=2) {
      if(listeners[i]==CellEditorListener.class) {
        // Lazily create the event:
        if(changeEvent == null) changeEvent = new ChangeEvent(this);
        ((CellEditorListener)listeners[i+1]).editingStopped(changeEvent);
      }
    }
  }
  protected void fireEditingCanceled() {
    // Guaranteed to return a non-null array
    Object[] listeners = listenerList.getListenerList();
    // Process the listeners last to first, notifying
    // those that are interested in this event
    for(int i = listeners.length-2; i&gt;=0; i-=2) {
      if(listeners[i]==CellEditorListener.class) {
        // Lazily create the event:
        if(changeEvent == null) changeEvent = new ChangeEvent(this);
        ((CellEditorListener)listeners[i+1]).editingCanceled(changeEvent);
      }
    }
  }
}
</code></pre>

### コメント
