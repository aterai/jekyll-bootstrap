---
layout: post
category: swing
folder: MultipleButtonsInTreeNode
title: JTreeのノードにクリック可能なJButtonを複数配置する
tags: [JTree, TreeCellEditor, TreeCellRenderer, JButton, JPanel]
author: aterai
pubdate: 2018-02-12T19:19:08+09:00
description: JTreeのセルエディタとしてクリック可能なJButtonを複数したJPanelを設定します。
image: https://drive.google.com/uc?id=1av1tLvTqv_249jfJdwdsuhEyB5i3zikC7Q
comments: true
---
## 概要
`JTree`のセルエディタとしてクリック可能な`JButton`を複数した`JPanel`を設定します。

{% download https://drive.google.com/uc?id=1av1tLvTqv_249jfJdwdsuhEyB5i3zikC7Q %}

## サンプルコード
<pre class="prettyprint"><code>class ButtonCellEditor extends AbstractCellEditor implements TreeCellEditor {
  private final ButtonPanel panel = new ButtonPanel();
  protected ButtonCellEditor() {
    super();
    panel.b1.addActionListener(e -&gt; {
      System.out.println("b1: " + panel.renderer.getText());
      stopCellEditing();
    });
    panel.b2.addActionListener(e -&gt; {
      System.out.println("b2: " + panel.renderer.getText());
      stopCellEditing();
    });
    panel.b3.addActionListener(e -&gt; {
      System.out.println("b3: " + panel.renderer.getText());
      stopCellEditing();
    });
  }

  @Override public Component getTreeCellEditorComponent(
      JTree tree, Object value, boolean isSelected, boolean expanded,
      boolean leaf, int row) {
    Component c = panel.renderer.getTreeCellRendererComponent(
        tree, value, true, expanded, leaf, row, true);
    return panel.remakePanel(c);
  }

  @Override public Object getCellEditorValue() {
    return panel.renderer.getText();
  }

  @Override public boolean isCellEditable(EventObject e) {
    Object source = e.getSource();
    if (!(source instanceof JTree) || !(e instanceof MouseEvent)) {
      return false;
    }
    JTree tree = (JTree) source;
    Point p = ((MouseEvent) e).getPoint();
    TreePath path = tree.getPathForLocation(p.x, p.y);
    if (Objects.isNull(path)) {
      return false;
    }
    Rectangle r = tree.getPathBounds(path);
    if (Objects.isNull(r)) {
      return false;
    }
    // r.width = panel.getButtonAreaWidth();
    // return r.contains(p);
    if (r.contains(p)) {
      TreeNode node = (TreeNode) path.getLastPathComponent();
      int row = tree.getRowForLocation(p.x, p.y);
      Component c = tree.getCellRenderer().getTreeCellRendererComponent(
          tree, " ", true, true, node.isLeaf(), row, true);
      c.setBounds(r);
      c.setLocation(0, 0);
      // tree.doLayout();
      tree.revalidate();
      p.translate(-r.x, -r.y);
      Component o = SwingUtilities.getDeepestComponentAt(c, p.x, p.y);
      if (o instanceof JButton) {
        return true;
      }
    }
    return false;
  }
}
</code></pre>

## 解説
上記のサンプルでは、`3`つの`JButton`と`JLabel`を継承する`DefaultTreeCellRenderer`を`FlowLayout`で配置する`JPanel`を`2`つ作成し、それぞれを`JTree`のセルエディタとセルレンダラーとして設定しています。

- セルレンダラーの`JButton`は表示にのみ使用するめ、`ActionListener`などは設定しない
- セルエディタの`JButton`には`JTree`のノードが編集可能になって自身がクリックされたときに実行する`ActionListener`を設定
    - この`ActionListener`が実行されたあと`AbstractCellEditor#stopCellEditing()`を実行して`JTree`のノード編集を終了する
    - `JTree`のノード編集を終了しないと、編集中のノードの各ボタンにフォーカスが描画されたり、別ノードのボタンを`2`回クリックしないとそのボタンのイベントが実行できない
- `TreeCellEditor#isCellEditable(...)`をオーバーライドし、マウスで各`JButton`の表示領域がクリックされた場合のみ編集可能に設定
    - `JButton`の表示領域がクリックされたかどうかの判断は編集開始前なのでセルエディタではなく、セルレンダラー内を`SwingUtilities.getDeepestComponentAt(...)`で検索して`JButton`が返されるかを調査している
- 編集中のノードの`JButton`のみマウスでクリック可能

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTreeのセルエディタにJComboBoxなどを配置したJPanelを使用する](https://ateraimemo.com/Swing/ComboBoxCellEditor.html)

<!-- dummy comment line for breaking list -->

## コメント
