---
layout: post
category: swing
folder: DefaultEditorKit
title: DefaultEditorKitでポップアップメニューからコピー
tags: [DefaultEditorKit, JTextField, JTextComponent, JPopupMenu]
author: aterai
pubdate: 2005-07-25T08:41:31+09:00
description: DefaultEditorKitを使って、JTextFieldなどでポップアップメニューを使ったコピー、貼り付け、切り取りを行います。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTKk8KGiNI/AAAAAAAAAWM/dJouzZuxv6g/s800/DefaultEditorKit.png
comments: true
---
## 概要
`DefaultEditorKit`を使って、`JTextField`などでポップアップメニューを使ったコピー、貼り付け、切り取りを行います。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTKk8KGiNI/AAAAAAAAAWM/dJouzZuxv6g/s800/DefaultEditorKit.png %}

## サンプルコード
<pre class="prettyprint"><code>//textField.setComponentPopupMenu(new TextFieldPopupMenu());
class TextFieldPopupMenu extends JPopupMenu {
  private final Action cutAction = new DefaultEditorKit.CutAction();
  private final Action copyAction = new DefaultEditorKit.CopyAction();
  private final Action pasteAction = new DefaultEditorKit.PasteAction();
  private final Action deleteAction = new AbstractAction("delete") {
    @Override public void actionPerformed(ActionEvent e) {
      Component c = getInvoker();
      if (c instanceof JTextComponent) {
        ((JTextComponent) c).replaceSelection(null);
      }
    }
  };
  private final Action cut2Action = new AbstractAction("cut2") {
    @Override public void actionPerformed(ActionEvent e) {
      Component c = getInvoker();
      if (c instanceof JTextComponent) {
        ((JTextComponent) c).cut();
      }
    }
  };
  protected TextFieldPopupMenu() {
    super();
    add(cutAction);
    add(copyAction);
    add(pasteAction);
    add(deleteAction);
    addSeparator();
    add(cut2Action);
  }
  @Override public void show(Component c, int x, int y) {
    if (c instanceof JTextComponent) {
      JTextComponent tc = (JTextComponent) c;
      boolean f =  tc.getSelectionStart() != tc.getSelectionEnd();
      cutAction.setEnabled(f);
      copyAction.setEnabled(f);
      deleteAction.setEnabled(f);
      cut2Action.setEnabled(f);
      super.show(c, x, y);
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、`DefaultEditorKit.CopyAction`をポップアップメニューに追加してクリップボードを使ったコピーなどを可能にしています。

- サンプルの`cut2`のように、`JTextComponent#cut()`メソッドなどを使用する方法もある

<!-- dummy comment line for breaking list -->

- - - -
サンプルを`Java Web Start`で起動した場合は、システム全体の共有クリップボードにはアクセス不可能で、アプリケーション内部のみでのコピー、貼り付けとなります。

- [ClipboardServiceでシステム全体の共有クリップボードにアクセスする](https://ateraimemo.com/Swing/ClipboardService.html)

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTKnUb6nqI/AAAAAAAAAWQ/L3ylLdA-GIw/s800/DefaultEditorKit1.png)

## 参考リンク
- [JTextFieldでコピー、貼り付けなどを禁止](https://ateraimemo.com/Swing/ActionMap.html)
- [DefaultEditorKit (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/DefaultEditorKit.html)

<!-- dummy comment line for breaking list -->

## コメント
- 「今後この警告を表示しない」をやめて、セキュリティの警告を表示したいけど、やり方が分からないorz。 -- *aterai* 2008-02-06 (水) 13:00:48

<!-- dummy comment line for breaking list -->
