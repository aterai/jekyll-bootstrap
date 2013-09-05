---
layout: post
title: JTreeの葉ノードをJCheckBoxにする
category: swing
folder: CheckBoxNodeTree
tags: [JTree, JCheckBox, TreeCellRenderer, TreeCellEditor]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-03-21

## JTreeの葉ノードをJCheckBoxにする
`JTree`の葉ノードを編集可能な`JCheckBox`にします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TYb2-BFsTHI/AAAAAAAAA4U/Fs8-t9x9XSw/s800/CheckBoxNodeTree.png)

### サンプルコード
<pre class="prettyprint"><code>class CheckBoxNode {
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
</code></pre>
<pre class="prettyprint"><code>JTree tree = new JTree() {
  @Override public void updateUI() {
    setCellRenderer(null);
    setCellEditor(null);
    super.updateUI();
    //???: JDK 1.6.0 LnF bug???
    setCellRenderer(new CheckBoxNodeRenderer());
    setCellEditor(new CheckBoxNodeEditor());
  }
};
</code></pre>
<pre class="prettyprint"><code>class CheckBoxNodeRenderer extends JCheckBox implements TreeCellRenderer {
  @Override public Component getTreeCellRendererComponent(JTree tree,
      Object value, boolean selected, boolean expanded, boolean leaf, int row, boolean hasFocus) {
    this.tree = tree;
    if(leaf &amp;&amp; value != null &amp;&amp; value instanceof DefaultMutableTreeNode) {
      this.setEnabled(tree.isEnabled());
      this.setFont(tree.getFont());
      this.setOpaque(false);
      Object userObject = ((DefaultMutableTreeNode)value).getUserObject();
      if(userObject!=null &amp;&amp; userObject instanceof CheckBoxNode) {
        CheckBoxNode node = (CheckBoxNode)userObject;
        this.setText(node.text);
        this.setSelected(node.selected);
      }
      return this;
    }
    return renderer.getTreeCellRendererComponent(tree, value, selected, expanded, leaf, row, hasFocus);
  }
  private JTree tree = null;
  private DefaultTreeCellRenderer renderer = new DefaultTreeCellRenderer();
  @Override public void updateUI() {
    super.updateUI();
    setName("Tree.cellRenderer");
  }
}
</code></pre>
<pre class="prettyprint"><code>class CheckBoxNodeEditor extends JCheckBox implements TreeCellEditor {
  private final JTree tree;
  public CheckBoxNodeEditor(JTree tree) {
    super();
    this.tree = tree;
    setFocusable(false);
    setRequestFocusEnabled(false);
    setOpaque(false);
    addActionListener(new ActionListener() {
      @Override public void actionPerformed(ActionEvent e) {
        stopCellEditing();
      }
    });
  }
  @Override public Component getTreeCellEditorComponent(JTree tree,
      Object value, boolean isSelected, boolean expanded, boolean leaf, int row) {
    if(leaf &amp;&amp; value != null &amp;&amp; value instanceof DefaultMutableTreeNode) {
      Object userObject = ((DefaultMutableTreeNode)value).getUserObject();
      if(userObject!=null &amp;&amp; userObject instanceof CheckBoxNode) {
        this.setSelected(((CheckBoxNode)userObject).selected);
      }else{
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
    if(e != null &amp;&amp; e instanceof MouseEvent) {
      TreePath path = tree.getPathForLocation(
          ((MouseEvent)e).getX(), ((MouseEvent)e).getY());
      Object o = path.getLastPathComponent();
      if(o!=null &amp;&amp; o instanceof TreeNode) {
        return ((TreeNode)o).isLeaf();
      }
    }
    return false;
  }
//......
</code></pre>

### 解説
`JCheckBox`を継承する`TreeCellRenderer`、`TreeCellEditor`を作成して、`setEditable(true)`とした`JTree`に設定し、葉ノードをチェックできるようにしています。ノードがチェックされているかどうかといった状態の保存は、`DefaultMutableTreeNode#setUserObject(Object)`でタイトルと選択状態をもつオブジェクトを設定することで行っています。

- - - -
葉ノードでない場合、表示には`DefaultTreeCellRenderer`を使っています。逆に`DefaultTreeCellRenderer`を継承する`TreeCellRenderer`で、葉ノードの表示を`JCheckBox`に委譲する方法でも同様となりますが、この場合、`JDK 1.6.0`では`Look And Feel`を変更してもアイコンや選択色が更新されないようです。

- `JDK 1.7.0`で修正されている

<!-- dummy comment line for breaking list -->

- - - -
葉ノードだけ編集可能に制限するため、`TreeCellEditor#isCellEditable(EventObject)`でクリックしたノードが`TreeNode#isLeaf()`かを判断しています。

- [JTreeの葉ノードだけ編集可能にする](http://terai.xrea.jp/Swing/LeafTreeCellEditor.html)

<!-- dummy comment line for breaking list -->

### 参考リンク
- [CheckNode - JTree Examples 2](http://www.crionics.com/products/opensource/faq/swing_ex/JTreeExamples2.html)
- [JTreeの葉ノードだけ編集可能にする](http://terai.xrea.jp/Swing/LeafTreeCellEditor.html)
- [JTreeのすべてのノードにJCheckBoxを追加する](http://terai.xrea.jp/Swing/CheckBoxNodeEditor.html)

<!-- dummy comment line for breaking list -->

### コメント