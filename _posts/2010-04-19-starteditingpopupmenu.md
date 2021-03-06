---
layout: post
category: swing
folder: StartEditingPopupMenu
title: JTreeのノード編集をPopupからのみに制限する
tags: [JTree, JPopupMenu, TreeCellEditor, JOptionPane]
author: aterai
pubdate: 2010-04-19T13:46:44+09:00
description: JTreeのノード編集をマウスクリックではなくPopupからのみに制限します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTTy9Cda5I/AAAAAAAAAlA/6uCGiCD2iGY/s800/StartEditingPopupMenu.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2013/03/jtree-node-edit-only-from-jpopupmenu.html
    lang: en
comments: true
---
## 概要
`JTree`のノード編集をマウスクリックではなく`Popup`からのみに制限します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTTy9Cda5I/AAAAAAAAAlA/6uCGiCD2iGY/s800/StartEditingPopupMenu.png %}

## サンプルコード
<pre class="prettyprint"><code>tree.setCellEditor(new DefaultTreeCellEditor(
    tree, (DefaultTreeCellRenderer) tree.getCellRenderer()) {
  @Override public boolean isCellEditable(EventObject e) {
    return !(e instanceof MouseEvent) &amp;&amp; super.isCellEditable(e);
  }

  // @Override protected boolean canEditImmediately(EventObject e) {
  //   // ((MouseEvent) e).getClickCount() &gt; 2
  //   return (e instanceof MouseEvent) ? false : super.canEditImmediately(e);
  // }
});
tree.setEditable(true);
tree.setComponentPopupMenu(new TreePopupMenu());
</code></pre>

## 解説
上記のサンプルでは、`DefaultTreeCellEditor#isCellEditable`メソッドをオーバーライドした`CellEditor`を設定することでノードをマウスでクリックしても編集開始できないように制限しています。

- - - -
編集開始のためのポップアップメニューは以下のような`2`種類を用意しています。

- `JTree#startEditingAtPath`メソッドを使用する
- `JOptionPane`を表示して編集する
    - 入力された文字列を`DefaultTreeModel#valueForPathChanged`メソッドで`JTree`に反映
        
        <pre class="prettyprint"><code>public TreePopupMenu() {
          super();
          add(new JMenuItem(new AbstractAction("Edit") {
            @Override public void actionPerformed(ActionEvent e) {
              JTree tree = (JTree) getInvoker();
              if (path != null) {
                tree.startEditingAtPath(path);
              }
            }
          }));
          add(new JMenuItem(new AbstractAction("Edit Dialog") {
            @Override public void actionPerformed(ActionEvent e) {
              JTree tree = (JTree) getInvoker();
              if (path == null) {
                return;
              }
              Object node = path.getLastPathComponent();
              if (node instanceof DefaultMutableTreeNode) {
                DefaultMutableTreeNode leaf = (DefaultMutableTreeNode) node;
                textField.setText(leaf.getUserObject().toString());
                int result = JOptionPane.showConfirmDialog(
                    tree, textField, "Rename",
                    JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);
                if (result == JOptionPane.OK_OPTION) {
                  String str = textField.getText();
                  if (!str.trim().isEmpty()) {
                    ((DefaultTreeModel) tree.getModel()).valueForPathChanged(path, str);
                  }
                }
              }
            }
          }));
          // ...
</code></pre>
    - * 参考リンク [#reference]
- [JTreeのノード上でJPopupMenuを表示](https://ateraimemo.com/Swing/TreeNodePopupMenu.html)

<!-- dummy comment line for breaking list -->

## コメント
