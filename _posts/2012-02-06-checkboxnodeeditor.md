---
layout: post
title: JTreeのすべてのノードにJCheckBoxを追加する
category: swing
folder: CheckBoxNodeEditor
tags: [JTree, JCheckBox, TreeCellRenderer, TreeCellEditor, TreeModelListener]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-02-06

## JTreeのすべてのノードにJCheckBoxを追加する
`JTree`のすべてのノードに編集可能な`JCheckBox`を追加します。

{% download %}

![screenshot](https://lh4.googleusercontent.com/-DK6aW3VNikg/TygxL3j8UoI/AAAAAAAABIw/6_9FyPe4v7U/s800/CheckBoxNodeEditor.png)

### サンプルコード
<pre class="prettyprint"><code>class CheckBoxNodeEditor extends TriStateCheckBox implements TreeCellEditor {
  private DefaultTreeCellRenderer renderer = new DefaultTreeCellRenderer();
  private final JPanel panel = new JPanel(new BorderLayout());
  private String str = null;
  public CheckBoxNodeEditor() {
    super();
    this.addActionListener(new ActionListener() {
      @Override public void actionPerformed(ActionEvent e) {
        //System.out.println("actionPerformed: stopCellEditing");
        stopCellEditing();
      }
    });
    panel.setFocusable(false);
    panel.setRequestFocusEnabled(false);
    panel.setOpaque(false);
    panel.add(this, BorderLayout.WEST);
    this.setOpaque(false);
  }
  @Override public Component getTreeCellEditorComponent(
      JTree tree, Object value, boolean isSelected,
      boolean expanded, boolean leaf, int row) {
    JLabel l = (JLabel)renderer.getTreeCellRendererComponent(
        tree, value, true, expanded, leaf, row, true);
    l.setFont(tree.getFont());
    if(value != null &amp;&amp; value instanceof DefaultMutableTreeNode) {
      this.setEnabled(tree.isEnabled());
      this.setFont(tree.getFont());
      Object userObject = ((DefaultMutableTreeNode)value).getUserObject();
      if(userObject!=null &amp;&amp; userObject instanceof CheckBoxNode) {
        CheckBoxNode node = (CheckBoxNode)userObject;
        if(node.status==Status.INDETERMINATE) {
          setIcon(new IndeterminateIcon());
        }else{
          setIcon(null);
        }
        l.setText(node.label);
        setSelected(node.status==Status.SELECTED);
        str = node.label;
      }
      //panel.add(this, BorderLayout.WEST);
      panel.add(l);
      return panel;
    }
    return l;
  }
  @Override public Object getCellEditorValue() {
    return new CheckBoxNode(str, isSelected()?Status.SELECTED:Status.DESELECTED);
  }
  @Override public boolean isCellEditable(EventObject e) {
    if(e != null &amp;&amp; e instanceof MouseEvent &amp;&amp; e.getSource() instanceof JTree) {
      MouseEvent me = (MouseEvent)e;
      JTree tree = (JTree)e.getSource();
      TreePath path = tree.getPathForLocation(me.getX(), me.getY());
      Rectangle r = tree.getPathBounds(path);
      if(r==null) return false;
      Dimension d = getPreferredSize();
      r.setSize(new Dimension(d.width, r.height));
      if(r.contains(me.getX(), me.getY())) {
        if(str==null &amp;&amp; System.getProperty("java.version").startsWith("1.7.0")) {
          System.out.println("XXX: Java 7, only on first run\n"+getBounds());
          setBounds(new Rectangle(0,0,d.width,r.height));
        }
        //System.out.println(getBounds());
        return true;
      }
    }
    return false;
  }
  @Override public void updateUI() {
    super.updateUI();
    setName("Tree.cellEditor");
    if(panel!=null) {
      //panel.removeAll(); //??? Change to Nimbus LnF, JDK 1.6.0
      panel.updateUI();
      //panel.add(this, BorderLayout.WEST);
    }
    //???#1: JDK 1.6.0 bug??? @see 1.7.0 DefaultTreeCellRenderer#updateUI()
    //if(System.getProperty("java.version").startsWith("1.6.0")) {
    //  renderer = new DefaultTreeCellRenderer();
    //}
  }
//...
</code></pre>

### 解説
上記のサンプルでは、`JCheckBox`を継承する`TreeCellEditor`、`TreeCellRenderer`を作成し、`TreeCellEditor#getTreeCellEditorComponent(...)`などは、この`JCheckBox`、`JLabel`(文字列、アイコン)などを含む`JPanel`を生成して返しています。

`JPanel`を継承する`TreeCellEditor`、`TreeCellRenderer`でも、`JDK 1.7.0`、`JDK 1.6.0_30`などでは、問題なく動作するようです。

<pre class="prettyprint"><code>class CheckBoxNodeRenderer extends JPanel implements TreeCellRenderer {
  private DefaultTreeCellRenderer renderer = new DefaultTreeCellRenderer();
  private final TriStateCheckBox check = new TriStateCheckBox();
  public CheckBoxNodeRenderer() {
    super(new BorderLayout());
    String uiName = getUI().getClass().getName();
    if(uiName.contains("Synth") &amp;&amp; System.getProperty("java.version").startsWith("1.7.0")) {
      System.out.println("XXX: FocusBorder bug?, JDK 1.7.0, Nimbus start LnF");
      renderer.setBackgroundSelectionColor(new Color(0,0,0,0));
    }
    setFocusable(false);
    setRequestFocusEnabled(false);
    setOpaque(false);
    add(check, BorderLayout.WEST);
    check.setOpaque(false);
  }
  @Override public Component getTreeCellRendererComponent(
      JTree tree, Object value, boolean selected,
      boolean expanded, boolean leaf, int row, boolean hasFocus) {
    JLabel l = (JLabel)renderer.getTreeCellRendererComponent(
        tree, value, selected, expanded, leaf, row, hasFocus);
    l.setFont(tree.getFont());
    if(value != null &amp;&amp; value instanceof DefaultMutableTreeNode) {
      check.setEnabled(tree.isEnabled());
      check.setFont(tree.getFont());
      Object userObject = ((DefaultMutableTreeNode)value).getUserObject();
      if(userObject!=null &amp;&amp; userObject instanceof CheckBoxNode) {
        CheckBoxNode node = (CheckBoxNode)userObject;
        if(node.status==Status.INDETERMINATE) {
          check.setIcon(new IndeterminateIcon());
        }else{
          check.setIcon(null);
        }
        l.setText(node.label);
        check.setSelected(node.status==Status.SELECTED);
      }
      add(l);
      return this;
    }
    return l;
  }
  @Override public void updateUI() {
    super.updateUI();
    if(check!=null) {
      //removeAll(); //??? Change to Nimbus LnF, JDK 1.6.0
      check.updateUI();
      //add(check, BorderLayout.WEST);
    }
    setName("Tree.cellRenderer");
    //???#1: JDK 1.6.0 bug??? @see 1.7.0 DefaultTreeCellRenderer#updateUI()
    //if(System.getProperty("java.version").startsWith("1.6.0")) {
    //  renderer = new DefaultTreeCellRenderer();
    //}
  }
}
</code></pre>

- - - -
ノードのチェック変更で、子ノードのチェックをすべて揃えたり、親ノードの状態変更は、`TreeModelListener`を追加して行なっています。

- - - -
- `JDK 1.6.0`で、`LookAndFeel`を`Nimbus`などに変更すると、セルエディタなどが更新されず？表示がおかしくなる場合があるので、`JTree#updateUI()`を以下のようにオーバーライドして回避

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>JTree tree = new JTree() {
  @Override public void updateUI() {
    setCellRenderer(null);
    setCellEditor(null);
    super.updateUI();
    //???#1: JDK 1.6.0 bug??? Nimbus LnF
    setCellRenderer(new CheckBoxNodeRenderer());
    setCellEditor(new CheckBoxNodeEditor());
  }
};
</code></pre>

- `JDK 1.7.0`で、初期`LookAndFeel`を`Nimbus`にすると、ノードにフォーカスがある場合のグラデーション描画がノードの背景色で塗りつぶされてしまう？のを、以下のようにして回避
    - https://lh3.googleusercontent.com/-DQgyx52YcsQ/T6sfFSWGIpI/AAAAAAAABMc/jAx8XeuMeWI/s800/CheckBoxNodeEditor1.png

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>public CheckBoxNodeRenderer() {
  super();
  String uiName = getUI().getClass().getName();
  if(uiName.contains("Synth") &amp;&amp;
     System.getProperty("java.version").startsWith("1.7.0")) {
    System.out.println("XXX: FocusBorder bug?, JDK 1.7.0, Nimbus start LnF");
    renderer.setBackgroundSelectionColor(new Color(0,0,0,0));
  }
//...
</code></pre>

- `JDK 1.7.0`で、ノードのチェックボックスをクリックしても、初回だけ反応しない。
    - `JDK 1.6.0_30`などは問題なし
    - `TreeCellEditor#isCellEditable()`をオーバーライドして、初回のみセルエディタのサイズを以下のように設定。

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>if(isFirstTime &amp;&amp; System.getProperty("java.version").startsWith("1.7.0")) {
  System.out.println("XXX: Java 7, only on first run\n"+getBounds());
  setBounds(new Rectangle(0,0,d.width,r.height));
}
</code></pre>

### 参考リンク
- [JTreeの葉ノードをJCheckBoxにする](http://terai.xrea.jp/Swing/CheckBoxNodeTree.html)
- [JCheckBoxに不定状態のアイコンを追加する](http://terai.xrea.jp/Swing/TriStateCheckBox.html)

<!-- dummy comment line for breaking list -->

### コメント
- 親ノードまでではなく、ルートノードまで不定状態の変更を行うように修正。 -- [aterai](http://terai.xrea.jp/aterai.html) 2012-03-23 (金) 17:43:32

<!-- dummy comment line for breaking list -->

