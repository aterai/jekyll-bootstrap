---
layout: post
category: swing
folder: ComboBoxCellEditor
title: JTreeのセルエディタにJComboBoxなどを配置したJPanelを使用する
tags: [JTree, TreeCellEditor, TreeCellRenderer, JComboBox, JPanel]
author: aterai
pubdate: 2014-06-09T01:29:59+09:00
description: JTreeのセルエディタ、セルレンダラーとして、JComboBoxなどを配置したJPanelを使用します。
image: https://lh4.googleusercontent.com/-kNa0cfgyvbY/U5SIYOWjVtI/AAAAAAAACHM/XkjN37IzSas/s800/ComboBoxCellEditor.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2017/05/use-jcombobox-as-jtrees-node-cell-editor.html
    lang: en
comments: true
---
## 概要
`JTree`のセルエディタ、セルレンダラーとして、`JComboBox`などを配置した`JPanel`を使用します。

{% download https://lh4.googleusercontent.com/-kNa0cfgyvbY/U5SIYOWjVtI/AAAAAAAACHM/XkjN37IzSas/s800/ComboBoxCellEditor.png %}

## サンプルコード
<pre class="prettyprint"><code>class PluginCellEditor extends DefaultCellEditor {
  private final PluginPanel panel;
  private transient Node node;

  public PluginCellEditor(JComboBox&lt;String&gt; comboBox) {
    super(comboBox);
    panel = new PluginPanel(comboBox);
  }

  @Override public Component getTreeCellEditorComponent(
      JTree tree, Object value, boolean selected, boolean expanded,
      boolean leaf, int row) {
    Node node = panel.extractNode(value);
    panel.setContents(node);
    this.node = node;
    return panel;
  }

  @Override public Object getCellEditorValue() {
    Object o = super.getCellEditorValue();
    if (node == null) {
      return o;
    }
    DefaultComboBoxModel&lt;String&gt; m =
        (DefaultComboBoxModel&lt;String&gt;) panel.comboBox.getModel();
    Node n = new Node(panel.pluginName.getText(), node.plugins);
    n.setSelectedPluginIndex(m.getIndexOf(o));
    return n;
  }

  @Override public boolean isCellEditable(EventObject e) {
    Object source = e.getSource();
    if (!(source instanceof JTree) || !(e instanceof MouseEvent)) {
      return false;
    }
    JTree tree = (JTree) source;
    MouseEvent me = (MouseEvent) e;
    TreePath path = tree.getPathForLocation(me.getX(), me.getY());
    if (path == null) {
      return false;
    }
    Object node = path.getLastPathComponent();
    if (!(node instanceof DefaultMutableTreeNode)) {
      return false;
    }
    Rectangle r = tree.getPathBounds(path);
    if (r == null) {
      return false;
    }
    Dimension d = panel.getPreferredSize();
    r.setSize(new Dimension(d.width, r.height));
    if (r.contains(me.getX(), me.getY())) {
      showComboPopup(tree, me);
      return true;
    }
    return delegate.isCellEditable(e);
  }

  private void showComboPopup(final JTree tree, final MouseEvent me) {
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        Point pt = SwingUtilities.convertPoint(tree, me.getPoint(), panel);
        Component o = SwingUtilities.getDeepestComponentAt(panel, pt.x, pt.y);
        if (o instanceof JComboBox) {
          panel.comboBox.showPopup();
        } else if (o != null) {
          Container c = SwingUtilities.getAncestorOfClass(
              JComboBox.class, (Component) o);
          if (c instanceof JComboBox) {
            panel.comboBox.showPopup();
          }
        }
      }
    });
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JLabel`と`JComboBox`を配置した`JPanel`を描画や編集に移譲する`TreeCellRenderer`と`TreeCellEditor`を作成して、それぞれ、`JTree#setCellRenderer(...)`、`JTree#setCellEditor(...)`で設定しています。

- - - -
- `TreeCellEditor`には、コンストラクタで`JComboBox`を設定する`DefaultCellEditor`を使用しているが、この`JComboBox`は`JPanel`の子要素になるため、一回目のクリックでノードが編集開始されたときに`JComboBox`のドロップダウンリストを開くことができない
    - 二回目ならすでにセルエディタとして`JPanel`自体が`JTree`の前面に表示されているので、子コンポーネントの`JComboBox`をクリックすればドロップダウンリストが開く
- そのため、このサンプルでは`TreeCellEditor#isCellEditable(...)`をオーバーライドし、ノード(`JPanel`)のクリックされた位置に存在するコンポーネントが`JComboBox`(または`JComboBox`内にある`ArrowButton`)の場合は、編集が開始された後(`EventQueue.invokeLater(...)`を使用してセルエディタが表示された後で実行)、`JComboBox.showPopup()`メソッドを実行してドロップダウンリストを開くように設定している

<!-- dummy comment line for breaking list -->

## 参考リンク
- [java - JTree selection issue - Stack Overflow](https://stackoverflow.com/questions/23900512/jtree-selection-issue)

<!-- dummy comment line for breaking list -->

## コメント
