---
layout: post
title: DefaultEditorKitでポップアップメニューからコピー
category: swing
folder: DefaultEditorKit
tags: [DefaultEditorKit, JTextField, JTextComponent, JPopupMenu]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-07-25

## DefaultEditorKitでポップアップメニューからコピー
`DefaultEditorKit`を使って、`JTextField`などでポップアップメニューを使ったコピー、貼り付け、切り取りを行います。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh6.ggpht.com/_9Z4BYR88imo/TQTKk8KGiNI/AAAAAAAAAWM/dJouzZuxv6g/s800/DefaultEditorKit.png)

### サンプルコード
<pre class="prettyprint"><code>textField.setComponentPopupMenu(new TextFieldPopupMenu(textField));
</code></pre>

<pre class="prettyprint"><code>class TextFieldPopupMenu extends JPopupMenu {
  private final Action cutAction = new DefaultEditorKit.CutAction();
  private final Action copyAction = new DefaultEditorKit.CopyAction();
  private final Action pasteAction = new DefaultEditorKit.PasteAction();
  private final Action deleteAction;
  private final Action cut2Action;
  public TextFieldPopupMenu(final JTextField field) {
    super();
    add(cutAction);
    add(copyAction);
    add(pasteAction);
    add(deleteAction = new AbstractAction("delete") {
      @Override public void actionPerformed(ActionEvent evt) {
        field.replaceSelection(null);
      }
    });
    addSeparator();
    add(cut2Action = new AbstractAction("cut2") {
      @Override public void actionPerformed(ActionEvent evt) {
        field.cut();
      }
    });
  }
  @Override public void show(Component c, int x, int y) {
    JTextField field = (JTextField)c;
    boolean flg = field.getSelectedText()!=null;
    cutAction.setEnabled(flg);
    copyAction.setEnabled(flg);
    deleteAction.setEnabled(flg);
    cut2Action.setEnabled(flg);
    super.show(c, x, y);
  }
}
</code></pre>

### 解説
`DefaultEditorKit`には、エディタとして必要な最小限度の機能がデフォルトで実装されています。上記のサンプルでは、`DefaultEditorKit.CopyAction`で、システムクリップボードを使ったコピーをポップアップメニューで行っています。

サンプルの"切り取り2"のように、`JTextComponent#cut()`などを使っても同様のことが行えます。

- - - -
サンプルを`Java Web Start`で起動した場合は、システム全体の共有クリップボードにはアクセス不可能で、アプリケーション内部のみでのコピー、貼り付けとなるようです。

- [ClipboardServiceでシステム全体の共有クリップボードにアクセスする](http://terai.xrea.jp/Swing/ClipboardService.html)

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTKnUb6nqI/AAAAAAAAAWQ/L3ylLdA-GIw/s800/DefaultEditorKit1.png)

### 参考リンク
- [JTextFieldでコピー、貼り付けなどを禁止](http://terai.xrea.jp/Swing/ActionMap.html)

<!-- dummy comment line for breaking list -->

### コメント
- 「今後この警告を表示しない」をやめて、セキュリティの警告を表示したいけど、やり方が分からないorz。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-02-06 (水) 13:00:48

<!-- dummy comment line for breaking list -->
