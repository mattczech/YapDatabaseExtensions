//
//  Persistable_AnyWithObjectMetadata.swift
//  YapDatabaseExtensions
//
//  Created by Daniel Thorpe on 13/10/2015.
//
//

import Foundation
import ValueCoding

// MARK: - Readable

extension Readable where
    ItemType: Persistable {

    func metadataInTransaction<Metadata: NSCoding>(_ transaction: Database.Connection.ReadTransaction, atIndex index: YapDB.Index) -> Metadata? {
        return transaction.readMetadataAtIndex(index)
    }

    func metadataAtIndexInTransaction<Metadata: NSCoding>(_ index: YapDB.Index) -> (Database.Connection.ReadTransaction) -> Metadata? {
        return { self.metadataInTransaction($0, atIndex: index) }
    }

    func metadataInTransactionAtIndex<Metadata: NSCoding>(_ transaction: Database.Connection.ReadTransaction) -> (YapDB.Index) -> Metadata? {
        return { self.metadataInTransaction(transaction, atIndex: $0) }
    }

    func metadataAtIndexesInTransaction<
        Indexes, Metadata>(_ indexes: Indexes) -> (Database.Connection.ReadTransaction) -> [Metadata?] where
        Indexes: Sequence,
        Indexes.Iterator.Element == YapDB.Index,
        Metadata: NSCoding {
            return { indexes.map(self.metadataInTransactionAtIndex($0)) }
    }

    /**
    Reads the metadata at a given index.

    - parameter index: a YapDB.Index
    - returns: an optional `Metadata`
    */
    public func metadataAtIndex<
        Metadata>(_ index: YapDB.Index) -> Metadata? where
        Metadata: NSCoding {
        return sync(metadataAtIndexInTransaction(index))
    }

    /**
    Reads the metadata at the indexes.

    - parameter indexes: a SequenceType of YapDB.Index values
    - returns: an array of `Metadata`
    */
    public func metadataAtIndexes<
        Indexes, Metadata>(_ indexes: Indexes) -> [Metadata?] where
        Indexes: Sequence,
        Indexes.Iterator.Element == YapDB.Index,
        Metadata: NSCoding {
            return sync(metadataAtIndexesInTransaction(indexes))
    }
}
